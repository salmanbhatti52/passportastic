import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:passport_stamp/core/constants/constant_colors.dart';
import 'package:passport_stamp/core/constants/constant_strings.dart';
import 'package:passport_stamp/core/constants/constant_svg.dart';
import 'package:passport_stamp/feature/stamp/data/models/stamp_background.dart';
import 'package:passport_stamp/feature/stamp/data/models/travel_mode.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:scanguard/Models/validationModelAPI.dart';
import 'package:scanguard/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StampController extends GetxController {
  ValidationModelApi validationModelApi = ValidationModelApi();
  var load = false.obs;
  var loading = false.obs;
  Function()? onDataUpdated;
    var logger = Logger();
  late List<StampBackgroundModel> stampBackgrounds = [];
  late List<TravelMode> travelModes = [];
  String? imageData;

  StampBackgroundModel? selectedStampBackground;
  TravelMode? selectedTravelMode;
  String? selectedCountry;
  String? selectedWay;
  String? selectedDate;
  String? selectedTime;
  String? apiDate;
  String cityName = '';
  int selectedColorIndex = 0;
  late Color selectedColor;

  String? selectedCountryForDynamicStamp;
  String? travelModeAsset;
  String? stampAsset;
  String? stampAssetMain;

  bool isTransparent = false;
  bool isTriangle = false;

  Future<void> validateStamp() async {
    load.value = true; // Show loading indicator
    try {
      await validation(); // Call the validation function
      // Handle success, update UI accordingly
    } catch (e) {
      // Handle error
      print("Error during validation: $e");
    } finally {
      load.value = false; // Hide loading indicator
    }
  }

  @override
  void onInit() {
    super.onInit();
    validateStamp();
    populateAssets();
    selectedColor = Colors.black;
    selectedWay = ConstantStrings.way.first;
    loadTravelModeAsset();
  }

  @override
  void onClose() {
    Get.delete<StampController>();
    super.onClose();
  }

  Future populateAssets() async {
    Map<String, List<StampBackgroundModel>> groupedBackgrounds = {};

    for (int i = 0; i < ConstantStrings.stampBackgroundNames.length; i++) {
      String label = ConstantStrings.stampBackgroundNames[i];
      bool isTransparent = label.contains("Transparent");
      String key = label.replaceAll("-Transparent", "").trim();

      StampBackgroundModel model = StampBackgroundModel(
        id: i,
        label: label,
        assetLink: ConstantSvg.stampBackgrounds[i],
      );

      if (!groupedBackgrounds.containsKey(key)) {
        groupedBackgrounds[key] = [];
      }

      groupedBackgrounds[key]!.add(model);
    }

    // Sort and populate the stampBackgrounds list
    groupedBackgrounds.forEach((key, models) {
      models.sort((a, b) =>
      a.label.contains("Transparent") ? 1 : -1); // Regular before Transparent
      stampBackgrounds.addAll(models);
    });

    for (int i = 0; i < ConstantStrings.travelModes.length; i++) {
      travelModes.add(TravelMode(
          label: ConstantStrings.travelModes[i],
          assetLink: ConstantSvg.travelModes[i]));
    }
    selectedStampBackground = stampBackgrounds.first;
  }

  Future<void> loadTravelModeAsset() async {
    if (selectedTravelMode != null) {
      travelModeAsset =
          await rootBundle.loadString(selectedTravelMode!.assetLink).then(
                (value) => value.replaceAll(RegExp(r'black'),
                    "#${ConstantColors.stampColors[selectedColorIndex].value.toRadixString(16).substring(2)}"),
              );
    }

    if (selectedStampBackground != null) {
      stampAsset =
          await rootBundle.loadString(selectedStampBackground!.assetLink).then(
                (value) => value.replaceAll(RegExp(r'#ffffff'),
                    "#${ConstantColors.stampColors[selectedColorIndex].value.toRadixString(16).substring(2)}"),
              );
    }

    stampAssetMain = await rootBundle
        .loadString(
            'assets/passport/base_stamp/${isTransparent ? "fixed_stamp_transparent" : "fixed_stamp"}.svg')
        .then(
          (value) => isTransparent
              ? value.replaceAll(RegExp(r'white'),
                  "#${ConstantColors.stampColors[selectedColorIndex].value.toRadixString(16).substring(2)}")
              : value.replaceAll(RegExp(r'#black'), "#ffffff"),
        );
    update(["basic_stamp", "dynamic_stamp"]);
  }

  Future<void> convertWidgetToImage(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        String base64String = base64Encode(pngBytes);
        print(base64String);
        imageData = base64String;
        update(['converted_image']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  validation() async {
    try {
      prefs = await SharedPreferences.getInstance();
      userID = prefs?.getString('userID');
      var headersList = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var url =
          Uri.parse('https://portal.passporttastic.com/api/getPackageDetails');

      var body = {"passport_holder_id": "$userID"};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        validationModelApi = validationModelApiFromJson(resBody);
        print(
            "Stamps in Validation API: ${validationModelApi.data!.totalStamps}");
        print(resBody);
        if (validationModelApi.data!.totalStamps == 0) {
          // checkStamps();
        }
      } else {
        print(res.reasonPhrase);
        validationModelApi = validationModelApiFromJson(resBody);
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}

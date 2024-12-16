import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:passport_stamp/core/constants/constant_strings.dart';
import 'package:passport_stamp/core/helpers/size_box_extension.dart';
import 'package:passport_stamp/feature/stamp/presentation/stamp_controller.dart';
import 'package:passport_stamp/feature/stamp/presentation/widget/custom_text_field.dart';
import 'package:passport_stamp/feature/stamp/presentation/widget/date_selection_widget.dart';
import 'package:scanguard/Home/mainScreenHome.dart';
import 'package:scanguard/Home/shop.dart';
import 'package:scanguard/HomeButtons/PassportSection/passport.dart';
import 'package:scanguard/Models/departedDetailsModels.dart';
import 'package:scanguard/auth/signUpPage.dart';
import 'package:scanguard/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget/color_selector_widget.dart';
import 'widget/custom_dropdown_widget.dart';
import 'widget/dropdown_menu_item.dart';
import 'widget/dynamic_stamp.dart';
import 'widget/way_selection_widget.dart';

class StampScreen extends StatelessWidget {
  StampScreen({super.key});

  final StampController controller =
      Get.put(StampController(), permanent: false);

  final GlobalKey _globalKey = GlobalKey();

  String? imageData;
  static const travelModesData = [
    "Air",
    "Boat/Ship",
    "Bus",
    "Car",
    "Walk",
    "Motor Cycle",
    "Push Bike",
    "Train",
  ];
  int selectedTravelModes = 1;
  int selectedShapeIndex = 1;
  int? selectedColorIndex;
  String travelStatus = "DEPARTED";

  DepartedDetailsModels departedDetailsModels = DepartedDetailsModels();

  departedDetails() async {
    // try {
    prefs = await SharedPreferences.getInstance();
    userID = prefs?.getString('userID');
    String apiUrl = "$baseUrl/departure_details";
    print("api: $apiUrl");
    prefs = await SharedPreferences.getInstance();
    userID = prefs?.getString('userID');
    print("imageData: ${controller.imageData}");

    var Map = {
      "stamps_country": controller.selectedCountry,
      "passport_holder_id": userID,
      "stamps_city": controller.cityName,
      "transport_mode_id": selectedTravelModes,
      "stamp_shape_id": selectedShapeIndex,
      "stamps_color_id": selectedColorIndex ?? "1",
      "stamps_date": controller.selectedDate,
      "stamps_offset_rotation": "-5",
      "stamps_offset_vertical": "5",
      "stamps_offset_horizental": "8",
      "stamps_page_number": "24",
      "stamps_time": controller.selectedTime,
      "stamps_position_number": "12",
      "stamps_arrive_depart": travelStatus,
      "stamp_image": "${controller.imageData}"
    };
    print("MapData: $Map");
    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "stamps_country": controller.selectedCountry,
      "passport_holder_id": userID,
      "stamps_city": controller.cityName,
      "transport_mode_id": selectedTravelModes.toString(),
      "stamp_shape_id": selectedShapeIndex.toString(),
      "stamps_color_id": selectedColorIndex.toString(),
      "stamps_date": controller.apiDate.toString(),
      "stamps_offset_rotation": "-5",
      "stamps_offset_vertical": "5",
      "stamps_offset_horizental": "8",
      "stamps_page_number": "24",
      "stamps_time": controller.selectedTime.toString(),
      "stamps_position_number": "12",
      "stamps_arrive_depart": travelStatus.toString(),
      "stamp_image": "${controller.imageData}"
    });
    print("body: ${response.body}");
    final responseString = response.body;
    print("response_TravelDetailsModels: $responseString");
    print("status Code response_TravelDetailsModels: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("in 200 response_TravelDetailsModels");
      print("SuucessFull");
      departedDetailsModels = departedDetailsModelsFromJson(responseString);

      print(
          'response_TravelDetailsModels status: ${departedDetailsModels.status}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Get.delete<StampController>();
          },
          child: SvgPicture.asset(
            "assets/arrowBack1.svg",
            fit: BoxFit.scaleDown,
          ),
        ),
        title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1, right: 10, left: 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/approval.svg"),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Stamp Credits"),
                              const SizedBox(
                                width: 5,
                              ),
                              Obx(() {
                                return !controller.load.value
                                    ? Text(
                                        "${controller.validationModelApi.data!.totalStamps}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF000000)
                                                .withOpacity(0.5)),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : const Text("");
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                addHeight(10),
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 1),
                  child: Text(
                    "Complete the following to get the Arrival Stamp of your own choosing.  If you are not happy with your choices, please make alternative selections",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF141111).withOpacity(0.5)),
                  ),
                ),
                addHeight(10),
                //Way selection radio buttons
                GetBuilder<StampController>(
                  id: 'way_selection',
                  builder: (controller) {
                    return WaySelectionWidget(
                      controller: controller,
                      onWaySelected: (selectedLabel) {
                        // Handle the selected label here
                        print("Selected way: $selectedLabel");
                        travelStatus = selectedLabel;
                        print("TravelSTatus: $travelStatus");
                      },
                    );
                  },
                ),
                addHeight(20),
                //Dynamic Stamp Background selection Dropdown Widget
                CustomDropDownWidget(
                  onChange: (background) {
                    controller.selectedStampBackground = background;
                    selectedShapeIndex = controller.selectedStampBackground!.id;
                    int index = controller.stampBackgrounds.indexOf(background);
                    controller.isTransparent = false;
                    if (index > 10) {
                      controller.isTransparent = true;
                    }
                    if (background != null &&
                        background.label.toLowerCase().contains('triangle')) {
                      controller.isTriangle = true;
                    } else {
                      controller.isTriangle = false;
                    }
                    controller.loadTravelModeAsset();
                    print(
                        'Selected Stamp Background: ${controller.selectedStampBackground!.id}');
                    if (selectedShapeIndex == 0) {
                      selectedShapeIndex += 1;
                    }
                    print("Selected Shape Index: $selectedShapeIndex");
                  },
                  items: controller.stampBackgrounds
                      .map(
                        (item) => dropdownMenuItemWithSvg(item),
                      )
                      .toList(),
                  hint: "Select Stamp Background",
                  label: "Stamp Background",
                ),
                addHeight(20),
                //Travel Mode selection Dropdown Widget
                CustomDropDownWidget(
                  onChange: (value) {
                    controller.selectedTravelMode = value;
                    controller.loadTravelModeAsset();
                    controller.update(["dynamic_stamp"]);

                    // Find the index of the selected travel mode label in the list
                    // Assuming travelModesData is a List<String> and initialized properly
                    // Ensure controller.selectedTravelMode and its label are not null before proceeding
                    if (controller.selectedTravelMode?.label != null) {
                      selectedTravelModes = travelModesData
                          .indexOf(controller.selectedTravelMode!.label);

                      // Check if the label was found in the list (index != -1)
                      if (selectedTravelModes != -1) {
                        // Add 1 to the index to start counting from 1 instead of 0
                        // No need for null-aware operator here as selectedTravelModes is not null at this point
                        selectedTravelModes += 1;
                        print("selectedTravelModes: $selectedTravelModes");

                        print(
                            "Index of ${controller.selectedTravelMode!.label}: $selectedTravelModes");
                      } else {
                        print("Label not found in the list");
                      }
                    } else {
                      print("Selected travel mode or label is null");
                    }
                  },
                  items: controller.travelModes
                      .map(
                        (item) => dropdownMenuItemWithSvg(item),
                      )
                      .toList(),
                  hint: "Select Travel Mode",
                  label: "Travel Mode",
                ),
                addHeight(20),
                //Country selection Dropdown Widget
                CustomDropDownWidget(
                  onChange: (country) {
                    controller.selectedCountryForDynamicStamp = country;
                    controller.selectedCountry = country;
                    controller.loadTravelModeAsset();
                    controller.update(["dynamic_stamp"]);
                    print("country: $country");
                    // print("country: ${controller.travelModes.indexed}");
                  },
                  items: ConstantStrings.countries
                      .map(
                        (item) => dropdownMenuItem(item),
                      )
                      .toList(),
                  hint: "Select Country",
                  label: "Country",
                ),
                addHeight(20),
                //City Input field
                CustomTextField(
                  hint: "Enter City Name",
                  label: "City Name",
                  onChanged: (value) {
                    controller.cityName = value;
                    print("City: ${controller.cityName}");
                    controller.loadTravelModeAsset();
                  },
                ),

                addHeight(10),
                //Stamp color selection widget
                ColorSelectorWidget(
                  controller: controller,
                  onColorSelected: (selectedIndex) {
                    // selectedColorIndex = selectedIndex;
                    // Increment selectedIndex by 1 for display purposes
                    selectedColorIndex = selectedIndex + 1;
                    // Handle the adjusted index here, e.g., update the UI to show the adjusted index
                    print("Selected color index: $selectedColorIndex");
                  },
                ),
                addHeight(20),
                //Dynamic Stamp date selection widget
                DateSelectionWidget(
                  getDate: (date, formatted) {
                    controller.selectedDate = formatted;
                    controller.apiDate = date;

                    print("Date: $date");
                    print("Date2: $formatted");
                    controller.update(["basic_stamp", "dynamic_stamp"]);
                  },
                ),
                addHeight(20),
                // TimeSelectionWidget(
                //   getDate: (time) {
                //     controller.selectedTime = time;
                //
                //     print("Date: ${controller.selectedTime}");
                //     controller.update(["basic_stamp", "dynamic_stamp"]);
                //   },
                // ),
                // addHeight(20),
                // addHeight(100),
                // const BasicStamp(),
                RepaintBoundary(
                  key: _globalKey,
                  child: const DynamicStamp(),
                ),
                addHeight(20),
                // ElevatedButton(
                //   onPressed: () {
                //     controller.convertWidgetToImage(_globalKey);
                //   },
                //   child: const Text('Convert into Base64'),
                // ),
                // Row(
                //   children: [
                //     RepaintBoundary(
                //       key: _globalKey,
                //       child: const DynamicStamp(),
                //     ),
                //     const Spacer(),
                //     const DynamicStamp(),
                //   ],
                // ),

                // controller.loading.value == true
                //     ? const CircularProgressIndicator(
                //         color: Colors.orange,
                //         strokeWidth: 2,
                //       )
                //     :
                Obx(() => controller.loading.value == true
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              controller.loading.value = true;
                              await controller.convertWidgetToImage(_globalKey);
                              if (controller
                                      .validationModelApi.data!.totalStamps ==
                                  0) {
                                checkStamps(context);
                              } else if (controller
                                      .validationModelApi.data!.totalPages ==
                                  0) {
                                checkPassPortPages(context);
                              } else {
                                selectedColorIndex = 1;
                                selectedShapeIndex = 1;
                                bool isAnyFieldSet = [
                                  controller.cityName.isNotEmpty,
                                  selectedTravelModes >= 0,
                                  selectedShapeIndex >= 0,
                                  selectedColorIndex! >= 0,
                                  controller.selectedDate != null,
                                  // controller.selectedTime != null,
                                ].contains(true);

                                if (!isAnyFieldSet) {
                                  Fluttertoast.showToast(
                                      msg: "Please Select all Fields",
                                      backgroundColor: Colors.red);
                                } else {
                                  await departedDetails();
                                  if (departedDetailsModels.status ==
                                      "success") {
                                    Fluttertoast.showToast(
                                      msg: "Stamped successfully.",
                                      backgroundColor: Colors.green,
                                    );
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const ViewPassport();
                                      },
                                    ));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: departedDetailsModels.message
                                            .toString(),
                                        backgroundColor: Colors.red);
                                  }
                                }
                                // await departure();
                                // Navigator.push(context, MaterialPageRoute(
                                //   builder: (BuildContext context) {
                                //     return MainScreen();
                                //   },
                                // ));
                              }
                              controller.loading.value = false;
                            },
                            child: Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width * 0.94,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF65734),
                                    Color(0xFFFF8D74)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text(
                                  "Stamp My Passport",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Satoshi",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      )),

                // GetBuilder<StampController>(
                //   id: 'converted_image',
                //   builder: (controller) {
                //     return controller.imageData != null
                //         ? Image.memory(base64Decode(controller.imageData!))
                //         : const SizedBox.shrink();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkStamps(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'No additional stamps exist',
      desc: 'Click OK to go to the shop page.',
      btnCancelOnPress: () {
        Navigator.pop(context); // Close the dialog
      },
      btnOkOnPress: () {
        Navigator.pop(context); // Close the dialog
        // Navigate to the shop page (replace 'ShopPage' with your actual route)
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      },
    ).show();
  }

  checkPassPortPages(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'No additional stamped pages exist',
      desc: 'Click OK to go to the shop page.',
      btnCancelOnPress: () {
        Navigator.pop(context); // Close the dialog
      },
      btnOkOnPress: () {
        Navigator.pop(context); // Close the dialog
        // Navigate to the shop page (replace 'ShopPage' with your actual route)
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      },
    ).show();
  }
}

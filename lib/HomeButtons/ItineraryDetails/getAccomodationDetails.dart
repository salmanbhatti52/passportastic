// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/getAccomodationDetailsModels.dart';
import '../../auth/signUpNextPage.dart';
import '../../auth/signUpPage.dart';
import '../../main.dart';

class AccomodationDetailsPage extends StatefulWidget {
  final String? itinid;
  final String? itinname;
  const AccomodationDetailsPage({Key, key, this.itinid, this.itinname})
      : super(key: key);

  @override
  State<AccomodationDetailsPage> createState() =>
      _AccomodationDetailsPageState();
}

class _AccomodationDetailsPageState extends State<AccomodationDetailsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  int accommodationsPerPage = 1;
  GetAccomodationsDetailsModels getAccomodationsDetailsModels =
      GetAccomodationsDetailsModels();


  accommodationDetails() async {
    // try {

    prefs = await SharedPreferences.getInstance();
    userID = prefs?.getString('userID');

    String apiUrl = "$baseUrl/get_itinerary_accomodations";
      //  print("api url $apiUrl");
    print("api: $apiUrl");

    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
    }, body: {
      "travel_ltinerary_id": "${widget.itinid}",
      "passport_holder_id": "$userID",
    });
    final responseString = response.body;
    print("responseModels: $responseString");
    print("status Code Accomodation DetailsModels: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("in 200 itineraryAddModels");
      print("SuucessFull");
      getAccomodationsDetailsModels =
          getAccomodationsDetailsModelsFromJson(responseString);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      

      print(
          'AaccommodationModelsDetailsModels status: ${getAccomodationsDetailsModels.status}');
    } else {
      // Show a dialog box if data is not available
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Data is not available."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the page
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  int itemsPerPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    userID = prefs?.getString('userID');
    print("${widget.itinid}");
    accommodationDetails();
    print("$userID");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFF65734),
          ), // Show loading indicator
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                "assets/arrowBack1.svg",
              ),
            ),
          ),
          title: Text(
            "${widget.itinname}",
            style: const TextStyle(
              color: Color(0xFF525252),
              fontSize: 24,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
            ),
          ),
          centerTitle: true,
        
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SvgPicture.asset(
                "assets/log1.svg",
                height: 35.h,
                width: 108.w,
                color: const Color(0xFFF65734),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Accomodation Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF65734),
                fontSize: 24,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: SvgPicture.asset("assets/arrow1.svg"),
                    onPressed: () {
                      final dataLength =
                          getAccomodationsDetailsModels.data?.length ?? 0;
                      if (_currentPage > 0) {
                        _goToPage(_currentPage - 1);
                      }
                    },
                  ),
                  Text(
                    _currentPage >= 0 &&
                            _currentPage <
                                (getAccomodationsDetailsModels.data?.length ??
                                    0)
                        ? getAccomodationsDetailsModels
                                .data![_currentPage.toInt()].accomodationCity ??
                            ""
                        : "",
                    style: const TextStyle(
                      color: Color(0xFF525252),
                      fontSize: 16,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset("assets/arrow.svg"),
                    onPressed: () {
                      final dataLength =
                          getAccomodationsDetailsModels.data?.length ?? 0;
                      if (_currentPage < dataLength - 1) {
                        _goToPage(_currentPage + 1);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: (getAccomodationsDetailsModels.data?.length ??
                        0 / accommodationsPerPage)
                    .ceil(),
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final startIndex = index * accommodationsPerPage;
                  final endIndex = (startIndex + accommodationsPerPage) <=
                          (getAccomodationsDetailsModels.data?.length ?? 0)
                      ? (startIndex + accommodationsPerPage)
                      : (getAccomodationsDetailsModels.data?.length ?? 0);

                  final accommodationsForPage = getAccomodationsDetailsModels
                          .data
                          ?.sublist(startIndex, endIndex) ??
                      [];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 250,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x0F312E23),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "City",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        accommodationsForPage[
                                                    index % itemsPerPage]
                                                .accomodationCity ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      // ---
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      const Text(
                                        'Accommodation',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // ---
                                      Text(
                                        accommodationsForPage[
                                                    index % itemsPerPage]
                                                .accomodationName ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      // ---
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      const Text(
                                        'Type',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // ---
                                      Text(
                                        accommodationsForPage[
                                                    index % itemsPerPage]
                                                .accomodationType ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      // ---
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      const Text(
                                        'Check Out',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // ---
                                      Text(
                                        DateFormat('dd MMM yyyy').format(
                                          accommodationsForPage[
                                                      index % itemsPerPage]
                                                  .accomodationCheckoutDate ??
                                              DateTime.now(),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),

                                      // ---
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      const Text(
                                        'Check In',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // ---
                                      Text(
                                        DateFormat('dd MMM yyyy').format(
                                          accommodationsForPage[
                                                      index % itemsPerPage]
                                                  .accomodationCheckinDate ??
                                              DateTime.now(),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Breakfast",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // ---
                                      Text(
                                        accommodationsForPage[
                                                    index % itemsPerPage]
                                                .accomodationBreakfast ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      // ---
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                      ),
                                      const Text(
                                        'Nights',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      // ---
                                      Text(
                                        accommodationsForPage[
                                                    index % itemsPerPage]
                                                .accomodationNights ??
                                            '',
                                        style: const TextStyle(
                                          color: Color(0xFFF65734),
                                          fontSize: 18,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ---
                              ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicators(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFFFF8D74), Color(0xFFF65634)],
                    ),
                    shape: OvalBorder(),
                  ),
                  child: Center(child: SvgPicture.asset("assets/share1.svg")),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFFFF8D74), Color(0xFFF65634)],
                    ),
                    shape: OvalBorder(),
                  ),
                  child: Center(child: SvgPicture.asset("assets/print1.svg")),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }
  }

//   Future<List<int>> _generatePdf(BuildContext context) async {
//   final pdf = Document();

//   // Add the container content to the PDF
//   pdf.addPage(
//     MultiPage(
//       build: (context) => [
//         Container(
//           width: 284,
//           decoration: ShapeDecoration(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             shadows: [
//               BoxShadow(
//                 color: Color(0x0F312E23),
//                 blurRadius: 16,
//                 offset: Offset(0, 8),
//                 spreadRadius: 0,
//               )
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Add your container content here
//               ],
//            ) ),)
//       ],
//     ),
//   );

//   // Save the PDF document as a list of bytes
//   final pdfBytes = await pdf.save();

//   return pdfBytes;
// }

  List<Widget> _buildIndicators() {
    final dataLength = getAccomodationsDetailsModels.data?.length ?? 0;

    return List.generate(
      dataLength,
      (index) => Container(
        width: 10,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: _currentPage == index
              ? const Color(0xFFF65734)
              : const Color(0xFF9C9999),
        ),
      ),
    );
  }
}

class ContainerData {
  final String title;

  ContainerData({required this.title});
}

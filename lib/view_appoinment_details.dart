// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'account_screen.dart';
import 'appoinment_booking.dart';
import 'health_screening.dart';
import 'home_screen.dart';
import 'model/booking_model.dart';
import 'model/psycology_model.dart';
import 'model/user_model.dart';

// ignore: camel_case_types
class viewAppoinmentDetails extends StatefulWidget {
  const viewAppoinmentDetails({key, required this.bookingDetails});

  final String bookingDetails;

  @override
  State<viewAppoinmentDetails> createState() => _viewAppoinmentDetailsState();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null) OpenFile.open(payload);
  });
}

class _viewAppoinmentDetailsState extends State<viewAppoinmentDetails> {
  int _selectedIndex = 1;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Uint8List? _imageFile;

  String psyUrl =
      'https://firebasestorage.googleapis.com/v0/b/consel-me-6938b.appspot.com/o/psychologistImages%2Fuser.png?alt=media&token=192696e8-ec72-4886-889d-0a6fac05ddf8';
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController psychologistNameEditingController =
      TextEditingController();
  TextEditingController bookingStatusEditingController =
      TextEditingController();
  TextEditingController bookingTimeEditingController = TextEditingController();
  TextEditingController bookingDateditingController = TextEditingController();
  TextEditingController bookingDateEditingController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController psychologistPriceEditingController =
      TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bookingModel booking = bookingModel();
  UserModel loggedInUser = UserModel();
  psychologyModel chosenPsychologist = psychologyModel();
  final formKey = GlobalKey<FormState>();
  String bookingDate1 = '';

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      firstNameEditingController.text = "${loggedInUser.firstName}";

      setState(() {});
    });

    FirebaseFirestore.instance
        .collection("booking")
        .doc(widget.bookingDetails)
        .get()
        .then((value) {
      booking = bookingModel.fromMap(value.data());
      psychologistNameEditingController.text = "${booking.psychologyName}";
      psychologistNameEditingController.text = "${booking.psychologyName}";
      psyUrl = "${booking.imgUrl}";
      bookingTimeEditingController.text = "${booking.bookingTime}";
      bookingDateEditingController.text = "${booking.bookingDate}";
      psychologistPriceEditingController.text = "${booking.bookingFee}";
      bookingStatusEditingController.text = "${booking.bookingStatus}";

      setState(() {});
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));

        _selectedIndex = index;
      }

      if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const appoinment_booking()));

        _selectedIndex = index;
      }

      if (index == 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const health_screening()));
        _selectedIndex = index;
      }

      if (index == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const account_screen()));
        _selectedIndex = index;
      }
    });
  }

  Future getPdf(Uint8List screenShot) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.fill),
          );
        },
      ),
    );

    await [Permission.storage].request();

    Random random = new Random();
    int code = random.nextInt(99999);
    final filename = 'Booking Receipt_$code.pdf';

    String filePath = '/storage/emulated/0/Download/$filename';

    File pdfFile = File(filePath);

    pdfFile.writeAsBytesSync(await pdf.save());
    Fluttertoast.showToast(msg: "PDF file have been downloaded");

    final android = AndroidNotificationDetails('0', 'ConSel-Me',
        channelDescription: 'Save Download',
        priority: Priority.high,
        importance: Importance.max,
        icon: '@mipmap/launcher_icon');
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      0,
      filename,
      'Download complete.',
      platform,
      payload: filePath,
    );

    OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: firstNameEditingController,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final psycologistNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: psychologistNameEditingController,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final bookingStatusField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: bookingStatusEditingController,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final psycologistPriceNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: psychologistPriceEditingController,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final bookingDateField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: bookingDateEditingController,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
            border: InputBorder.none,
            errorStyle: (TextStyle(
              fontSize: 10.0,
            ))));

    final timeField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: bookingTimeEditingController,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          errorStyle: (TextStyle(
            fontSize: 10.0,
          )),
        ));

    final printButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
        onPressed: () async {
          final image = await screenshotController.capture();
          _imageFile = image;
          getPdf(_imageFile!);
        },
        child: const Text(
          "Print",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        onPressed: () {
          showAlertDialog(context);
        },
        child: const Text(
          "Cancel \nBooking",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: const Text('Booking'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
      ),
      body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Column(
                      children: [
                        Container(
                            width: 300,
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 90, right: 90),
                            child: const Text(
                              'Booking Details',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(186, 255, 255, 255),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ))),
                        Container(
                            width: 300,
                            height: 310,
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                )),
                            child: Column(
                              children: [
                                Row(children: [
                                  SizedBox(
                                      height: 90,
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(
                                              48), // Image radius
                                          child: Image.network(psyUrl,
                                              fit: BoxFit.fill),
                                        ),
                                      )),
                                  const SizedBox(width: 20),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                          height: 50,
                                          width: 100,
                                          child: psycologistNameField),
                                      const Text(
                                        'Psychologist',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  )
                                ]),
                                Row(
                                  children: [
                                    const Text(
                                      'Patient Name: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: fullNameField),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Date: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: bookingDateField),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Time: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: timeField),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Booking Status: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: bookingStatusField),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(height: 20),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              )),
                          child: Row(
                            children: [
                              const Text(
                                'Consultation Fee :',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              const SizedBox(width: 25),
                              Row(
                                children: [
                                  const Text(
                                    "RM ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                      height: 50,
                                      width: 64,
                                      child: psycologistPriceNameField),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      cancelButton,
                      const SizedBox(width: 20),
                      printButton
                    ],
                  )
                ],
              ))),
      bottomNavigationBar: BottomNavigationBar(
        //currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Colors.black),
            label: 'Appoinment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box, color: Colors.black),
            label: 'Health Screening',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, color: Colors.black),
            label: 'Account',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = FlatButton(
      child: const Text("Yes"),
      onPressed: () {
        final docBooking = FirebaseFirestore.instance
            .collection('booking')
            .doc(widget.bookingDetails);

        docBooking.update({
          'bookingStatus': "Cancelled",
        });
        Fluttertoast.showToast(msg: "Your Booking have Been Cancelled");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text(
          "Are you sure you want to cancel your Appoinment Booking?"),
      actions: [
        yesButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

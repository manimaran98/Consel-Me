import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sampleproject/home_screen.dart';
import 'package:sampleproject/login_screen.dart';
import 'package:sampleproject/view_appoinment_details.dart';

import 'model/user_model.dart';

class checkUser extends StatefulWidget {
  const checkUser({Key? key}) : super(key: key);

  @override
  State<checkUser> createState() => _checkUserState();
}

class _checkUserState extends State<checkUser> {
  String role = 'user';
  String name = 'user';
  List data = [];
  int index = 0;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    _checkRole();
    getNotification();
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
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  onSelectNotification(String? payload) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => viewAppoinmentDetails(
                  bookingDetails: payload.toString(),
                )));
  }

  getNotification() async {
    final android = AndroidNotificationDetails('0', 'ConSel-Me',
        channelDescription: 'Notification Reminder',
        priority: Priority.high,
        importance: Importance.max,
        icon: '@mipmap/launcher_icon');
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    DateTime? date1 = DateTime.now();
    String date = DateFormat('dd/MM/yyyy').format(date1);
    print(date);
    await FirebaseFirestore.instance
        .collection("booking")
        .get()
        .then((value) async {
      for (var i in value.docs) {
        data.add(i.data());
        String bookDate = data[index]["bookingDate"];
        String user_id = data[index]["user_id"];
        String bookTime = data[index]["bookingTime"];
        String bookingStatus = data[index]["bookingStatus"];
        String bookingId = data[index]["bookingId"];
        String psychologyName = data[index]["psychologyName"];

        if ((bookDate == date.toString() &&
            user_id == user!.uid &&
            bookingStatus == "Upcoming")) {
          await flutterLocalNotificationsPlugin.show(
              0,
              "Appoinment Reminder",
              "Your appoinment with Dr " +
                  psychologyName +
                  " is at " +
                  bookTime,
              platform,
              payload: bookingId);
        }

        index++;
      }
    });
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
      name = snap['firstName'];
    });

    if (role != 'User') {
      navigateNext(LoginScreen());
      Fluttertoast.showToast(msg: "Unauthorised Access");
    } else if (role == 'User') {
      navigateNext(HomeScreen());
      Fluttertoast.showToast(msg: "Welcome " + name);
    }
  }

  void navigateNext(Widget route) {
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
            child: const CircularProgressIndicator(),
          ),
          color: Colors.white),
    );
  }
}

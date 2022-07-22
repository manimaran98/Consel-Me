import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sampleproject/appoinment_booking.dart';
import 'package:sampleproject/booking_screen.dart';
import 'package:sampleproject/health_screening.dart';
import 'account_screen.dart';
import 'model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  int _selectedIndex = 0;
  String fullname = "Loading...";
  String userId = "";

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
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

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      fullname = "${loggedInUser.firstName}";
      userId = "${loggedInUser.uid}";
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/homebg.jpg'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bookButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const bookingScreen()));
        },
        child: const Text(
          "Book Now",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      body: Container(
          color: const Color.fromARGB(255, 238, 238, 238),
          child: Column(children: <Widget>[
            Container(
              color: const Color.fromARGB(255, 35, 90, 190),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 70.0, left: 20.0, bottom: 30),
                child: Row(children: <Widget>[
                  SizedBox(
                      height: 120,
                      child:
                          Image.asset("assets/user.png", fit: BoxFit.contain)),
                  Column(children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 10.0, left: 30),
                      child: const Text(
                        "Welcome Back,",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, left: 30),
                      child: Text(fullname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ])
                ]),
              ),
            ),
            SizedBox(
              child: Image.asset(
                "assets/homebg.jpg",
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  child: const Text(
                    "Having Mental Break Down,\n Why not book a session ?",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  padding: const EdgeInsets.only(bottom: 30, top: 50),
                ),
                bookButton,
                const SizedBox(height: 20),
              ],
            ),
          ])),
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
}

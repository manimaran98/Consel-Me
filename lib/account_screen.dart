// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sampleproject/appoinment_booking.dart';
import 'package:sampleproject/change_password.dart';
import 'package:sampleproject/user_profile.dart';

import 'health_screening.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'model/user_model.dart';

class account_screen extends StatefulWidget {
  const account_screen({Key? key}) : super(key: key);

  @override
  State<account_screen> createState() => _account_screenState();
}

class _account_screenState extends State<account_screen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileButton = Material(
      elevation: 8,
      color: const Color.fromARGB(255, 238, 238, 238),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const user_profile()));
        },
        child: const Text(
          "Profile",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final passwordButton = Material(
      elevation: 5,
      color: const Color.fromARGB(255, 238, 238, 238),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(65, 20, 65, 20),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const changePassword()));
        },
        child: const Text(
          "Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final settingsButton = Material(
      elevation: 5,
      color: const Color.fromARGB(255, 238, 238, 238),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {},
        child: const Text(
          "Settings",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final logoutButton = Material(
      elevation: 5,
      color: const Color.fromARGB(255, 238, 238, 238),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          logout(context);
        },
        child: const Text(
          "Logout",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              color: const Color.fromARGB(255, 35, 90, 190),
              child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const Text(
                    "Account",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                    height: 120,
                    child: Image.asset("assets/user.png", fit: BoxFit.contain)),
                Column(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("${loggedInUser.firstName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ])
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              color: Colors.white,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 60),
                  profileButton,
                  const SizedBox(height: 60),
                  passwordButton,
                  const SizedBox(height: 60),
                  logoutButton,
                  const SizedBox(height: 62),
                ],
              ),
            )
          ]),
      bottomNavigationBar: BottomNavigationBar(
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

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

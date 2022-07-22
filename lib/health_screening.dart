// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sampleproject/account_screen.dart';
import 'package:sampleproject/chatbot.dart';
import 'package:sampleproject/resultDetails.dart';

import 'appoinment_booking.dart';
import 'home_screen.dart';
import 'model/user_model.dart';

class health_screening extends StatefulWidget {
  const health_screening({Key? key}) : super(key: key);

  @override
  State<health_screening> createState() => _health_screeningState();
}

class _health_screeningState extends State<health_screening> {
  int _selectedIndex = 2;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  int number = 1;
  String resultId = "";

  @override
  void initState() {
    super.initState();
    number = 1;
  }

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
        _selectedIndex = index;
        setState(() {});
        number = 1;
      }

      if (index == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const account_screen()));
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final testButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatBotScreen()));
        },
        child: const Text(
          "Take Test",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('Health Screening'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text('Screening Result',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  style: BorderStyle.solid,
                  width: 3,
                  color: const Color.fromARGB(255, 39, 38, 38))),
          width: 350,
          height: 450,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: getReusltList(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                padding: const EdgeInsets.only(top: 250),
                                child: const CircularProgressIndicator(),
                              );
                            } else {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data[index]
                                            .data()["userId"]
                                            .toString() ==
                                        (user!.uid)) {
                                      return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        color: const Color.fromARGB(
                                            255, 238, 238, 238),
                                        child: Column(
                                          children: [
                                            Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  (number++).toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Screening Result :  " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "condition"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        'Screening Date    :  ' +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "resultDate"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Material(
                                                            elevation: 5,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.blue,
                                                            child:
                                                                MaterialButton(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      5,
                                                                      2,
                                                                      5,
                                                                      2),
                                                              onPressed: () {
                                                                sendDetail(snapshot
                                                                    .data[index]
                                                                    .data()[
                                                                        "resultId"]
                                                                    .toString());
                                                              },
                                                              child: const Text(
                                                                "Check Result",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Material(
                                                            elevation: 5,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.red,
                                                            child:
                                                                MaterialButton(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      5,
                                                                      5,
                                                                      5,
                                                                      5),
                                                              onPressed: () {
                                                                resultId = snapshot
                                                                        .data[index]
                                                                        .data()[
                                                                    "resultId"];
                                                                showAlertDialog(
                                                                    context,
                                                                    resultId);
                                                              },
                                                              child: const Text(
                                                                "Delete Result",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container(
                                      color: Colors.white,
                                      // This is optional
                                    );
                                  });
                            }
                          }),
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        testButton
      ]),
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

  showAlertDialog(BuildContext context, resultId) {
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
        FirebaseFirestore.instance.collection("result").doc(resultId).delete();
        Navigator.of(context).pop();
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content:
          const Text("Are you sure you want to delete this screening result?"),
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

  Future getReusltList() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot result = await fireStore.collection("result").get();
    return result.docs;
  }

  sendDetail(resultData) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => resultDetails(
                  resultId: resultData,
                )));
  }
}

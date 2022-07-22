import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/confirm_booking.dart';
import 'package:sampleproject/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account_screen.dart';
import 'appoinment_booking.dart';
import 'health_screening.dart';

class bookingScreen extends StatefulWidget {
  const bookingScreen({Key? key}) : super(key: key);

  @override
  State<bookingScreen> createState() => _bookingScreenState();
}

class _bookingScreenState extends State<bookingScreen> {
  int _selectedIndex = 1;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();

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

  Future getPhycologistList() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot psychologist =
        await fireStore.collection("psychologists").get();

    return psychologist.docs;
  }

  catchDetail(String psychologist) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => confirmBooking(
                  psychologist: psychologist,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('Psychologist'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getPhycologistList(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 120,
                                      child: Image.network(
                                        snapshot.data[index]
                                            .data()["imgUrl"]
                                            .toString(),
                                        fit: BoxFit.fill,
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    Column(children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index]
                                                .data()["psychologyName"],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                            'RM ' +
                                                snapshot.data[index]
                                                    .data()["price"],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.greenAccent,
                                          child: MaterialButton(
                                            onPressed: () {
                                              catchDetail(snapshot.data[index]
                                                  .data()["psychologyId"]
                                                  .toString());
                                            },
                                            child: const Text(
                                              "Schedule Appointment",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  }
                }),
          ],
        ),
      )),
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

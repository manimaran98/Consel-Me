import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'account_screen.dart';
import 'appoinment_booking.dart';
import 'health_screening.dart';
import 'home_screen.dart';
import 'model/psycology_model.dart';
import 'model/booking_model.dart';
import 'model/user_model.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class confirmBooking extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const confirmBooking({key, required this.psychologist});

  final String psychologist;

  @override
  State<confirmBooking> createState() => _confirmBookingState();
}

// ignore: camel_case_types
class _confirmBookingState extends State<confirmBooking> {
  String selectedTime = '';
  DateTime date = DateTime.now();
  int _selectedIndex = 1;
  String? errorMessage;
  // ignore: prefer_typing_uninitialized_variables
  var dropDownItem;
  List data = [];
  int index = 0;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String psyUrl =
      "https://firebasestorage.googleapis.com/v0/b/consel-me-6938b.appspot.com/o/psychologistImages%2Fuser.png?alt=media&token=192696e8-ec72-4886-889d-0a6fac05ddf8";
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController psychologistNameEditingController =
      TextEditingController();
  TextEditingController bookingDateEditingController = TextEditingController();
  TextEditingController psychologistPriceEditingController =
      TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  psychologyModel chosenPsychologist = psychologyModel();
  final formKey = GlobalKey<FormState>();
  String bookingDate1 = '';
  String bookingDetails = "";

  late String option1;
  late String value1;
  late bool availability1;
  late String option2;
  late String value2;
  late bool availability2;
  late String option3;
  late String value3;
  late bool availability3;
  late String option4;
  late String value4;
  late bool availability4;
  late String option5;
  late String value5;
  late bool availability5;

  @override
  void initState() {
    super.initState();

    option1 = ' 10.00 AM';
    value1 = '10.00 AM';
    availability1 = true;
    option2 = ' 12.00 PM';
    value2 = '12.00 PM';
    availability2 = true;
    option3 = ' 2.00 PM';
    value3 = '2.00 PM';
    availability3 = true;
    option4 = ' 4.00 PM';
    value4 = '4.00 PM';
    availability4 = true;
    option5 = ' 6.00 PM';
    value5 = '6.00 PM';
    availability5 = true;

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
        .collection("psychologists")
        .doc(widget.psychologist)
        .get()
        .then((value) {
      chosenPsychologist = psychologyModel.fromMap(value.data());
      psychologistNameEditingController.text =
          "${chosenPsychologist.psychologyName}";
      psyUrl = "${chosenPsychologist.imgUrl}";
      psychologistPriceEditingController.text = "${chosenPsychologist.price}";
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

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: firstNameEditingController,
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
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
        onSaved: (value) {
          psychologistNameEditingController.text = value!;
        },
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
        onSaved: (value) {
          psychologistNameEditingController.text = value!;
        },
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final bookingDateField = TextFormField(
        controller: bookingDateEditingController,
        onTap: () async {
          DateTime? date = DateTime(1900);
          //FocusScope.of(context).requestFocus(FocusNode());

          date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: DateTime.now(),
              lastDate: DateTime(2100));
          bookingDateEditingController.text =
              DateFormat('dd/MM/yyyy').format(date ?? DateTime.now());

          option1 = ' 10.00 AM';
          value1 = '10.00 AM';
          availability1 = true;
          option2 = ' 12.00 PM';
          value2 = '12.00 PM';
          availability2 = true;
          option3 = ' 2.00 PM';
          value3 = '2.00 PM';
          availability3 = true;
          option4 = ' 4.00 PM';
          value4 = '4.00 PM';
          availability4 = true;
          option5 = ' 6.00 PM';
          value5 = '6.00 PM';
          availability5 = true;

          await firebaseFirestore.collection("booking").get().then((value) {
            for (var i in value.docs) {
              data.add(i.data());
              String bookDate = data[index]["bookingDate"];
              String bookTime = data[index]["bookingTime"];
              String psychologyId = data[index]["psychologyId"];
              String userId = data[index]["user_id"];
              String bookingStatus = data[index]["bookingStatus"];

              if ((bookDate == bookingDateEditingController.text &&
                  bookTime == value1 &&
                  psychologyId == widget.psychologist &&
                  bookingStatus == "Upcoming")) {
                option1 = ' 10.00 AM (Not Available)';
                value1 = '10.00 AM';
                availability1 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value2 &&
                  psychologyId == widget.psychologist &&
                  bookingStatus == "Upcoming") {
                option2 = ' 12.00 PM (Not Available)';
                value2 = '12.00 PM';
                availability2 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value3 &&
                  psychologyId == widget.psychologist &&
                  bookingStatus == "Upcoming") {
                option3 = ' 2.00 PM (Not Available)';
                value3 = '2.00 PM';
                availability3 = false;
              }
              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value4 &&
                  psychologyId == widget.psychologist &&
                  bookingStatus == "Upcoming") {
                option4 = ' 4.00 PM (Not Available)';
                value4 = '4.00 PM';
                availability4 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value5 &&
                  psychologyId == widget.psychologist &&
                  bookingStatus == "Upcoming") {
                option5 = ' 6.00 PM (Not Available)';
                value5 = '6.00 PM';
                availability5 = false;
              }
              if ((bookDate == bookingDateEditingController.text &&
                  userId == user!.uid &&
                  bookingStatus == "Upcoming")) {
                option1 = ' 10.00 AM (Not Available)';
                option2 = ' 12.00 PM (Not Available)';
                option3 = ' 2.00 PM (Not Available)';
                option4 = ' 4.00 PM (Not Available)';
                option5 = ' 6.00 PM (Not Available)';

                availability1 = false;
                availability2 = false;
                availability3 = false;
                availability4 = false;
                availability5 = false;
                Fluttertoast.showToast(
                    msg:
                        "User can only perform one appointment booking per-day");
              }
              index++;
            }
          });

          setState(() {});
        },
        onSaved: (value) {
          bookingDateEditingController.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            Fluttertoast.showToast(msg: "Booking Date Should not be Empty");
            return ("Booking Date is Required for Booking");
          }

          return null;
        },
        textInputAction: TextInputAction.next,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
            errorStyle: (TextStyle(
          fontSize: 10.0,
        ))));

    final timeField = DropdownButtonFormField(
        value: selectedTime,
        items: [
          const DropdownMenuItem(
            child: Text(""),
            value: "",
            enabled: false,
          ),
          DropdownMenuItem(
            child: Text(option1),
            value: value1,
            enabled: availability1,
          ),
          DropdownMenuItem(
            child: Text(option2),
            value: value2,
            enabled: availability2,
          ),
          DropdownMenuItem(
            child: Text(option3),
            value: value3,
            enabled: availability3,
          ),
          DropdownMenuItem(
            child: Text(option4),
            value: value4,
            enabled: availability4,
          ),
          DropdownMenuItem(
            child: Text(option5),
            value: value5,
            enabled: availability5,
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedTime = value.toString();
          });
        },
        validator: (option) {
          if (option == "") {
            Fluttertoast.showToast(msg: "Booking Time Should not be Empty");
            return ("Booking Time Should not be Empty");
          }
          return null;
        },
        onSaved: (value) {
          selectedTime = value.toString();
        },
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          errorStyle: (TextStyle(
            fontSize: 10.0,
          )),
        ));

    final bookButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(70, 30, 70, 30),
        onPressed: () {
          bookingAppoinment();
        },
        child: const Text(
          "Confirm Booking",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: const Text('Confirmation'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
      ),
      body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          width: 300,
                          margin: const EdgeInsets.only(top: 30),
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 90, right: 90),
                          child: const Text(
                            'Service Details',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 238, 238),
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
                              const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      bookButton
                    ],
                  ),
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

  void bookingAppoinment() async {
    if (formKey.currentState!.validate()) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      // ignore: non_constant_identifier_names
      bookingModel BookingModel = bookingModel();

      // writing all the values

      final document =
          firebaseFirestore.collection("booking").doc(BookingModel.bookingId);
      BookingModel.user_id = user!.uid;
      bookingDetails = document.id;
      BookingModel.bookingId = bookingDetails;
      BookingModel.psychologyName = psychologistNameEditingController.text;
      BookingModel.psychologyId = widget.psychologist;
      BookingModel.imgUrl = psyUrl;
      BookingModel.bookingDate = bookingDateEditingController.text;
      BookingModel.bookingTime = selectedTime;
      BookingModel.bookingFee = psychologistPriceEditingController.text;
      BookingModel.bookingStatus = 'Upcoming';

      await document.set(BookingModel.toMap());

      Fluttertoast.showToast(msg: "Successfully Booked Session");

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const appoinment_booking()),
          (route) => false);
    }
  }
}

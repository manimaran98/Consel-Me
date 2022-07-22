import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'confirm_booking.dart';

import 'model/psycology_model.dart';
import 'model/result_model.dart';

class resultDetails extends StatefulWidget {
  const resultDetails({key, required this.resultId});

  final String resultId;

  @override
  State<resultDetails> createState() => _resultDetailsState();
}

class _resultDetailsState extends State<resultDetails> {
  resultModel chosenResultData = resultModel();
  psychologyModel psychology = psychologyModel();
  String patientResultDate = '';
  String patientResultTime = '';
  late String psychologistName = "";
  late String psychologistId = "";
  late String patientCondition = "";
  String conditionImg = 'assets/depression.png';
  String conditionText = "";
  String psyImg =
      "https://firebasestorage.googleapis.com/v0/b/consel-me-6938b.appspot.com/o/psychologistImages%2Fuser.png?alt=media&token=192696e8-ec72-4886-889d-0a6fac05ddf8";
  String psyPrice = "";
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("result")
        .doc(widget.resultId)
        .get()
        .then((value) {
      chosenResultData = resultModel.fromMap(value.data());
      psychologistId = "${chosenResultData.psychologyId}";
      patientCondition = "${chosenResultData.condition}";
      patientResultDate = "${chosenResultData.resultDate}";
      patientResultTime = "${chosenResultData.resultTime}";
      getPsyData(psychologistId);
      setState(() {});
    });
  }

  getPsyData(psychologistId) {
    FirebaseFirestore.instance
        .collection("psychologists")
        .doc(psychologistId)
        .get()
        .then((value) {
      psychology = psychologyModel.fromMap(value.data());

      setState(() {
        psychologistName = "${psychology.psychologyName}";
        psyImg = "${psychology.imgUrl}";
        psyPrice = "${psychology.price}";
      });
    });
    if (patientCondition == "Depression") {
      conditionImg = 'assets/depression.png';
      conditionText =
          "Depression is a low mood that lasts for a long time, affecting everyday life. It is often triggered by a mix of genetic, psychological and environmental factors.";
    }

    if (patientCondition == "Mental Disorder") {
      conditionImg = 'assets/mental.jpg';
      conditionText =
          "A mental disorder is characterized by a clinically significant disturbance in an individual's cognition, emotional regulation, or behaviour.";
    }

    if (patientCondition == "Anxiety") {
      conditionImg = 'assets/anxiety.png';
      conditionText =
          "Anxiety is a common emotion when dealing with daily stresses and problems where emotions are persistent, excessive and irrational.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 90, 190),
          elevation: 0,
          title: const Text('Screening Result'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          margin: const EdgeInsets.all(35),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: 400,
                  width: 400,
                  child: SizedBox(
                      child: Column(
                    children: [
                      const Text("\nResult",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Text(
                            "\nBased on the test, seems to be like you are suffering from $patientCondition. My advice, Dr $psychologistName is the most suitable psychologist on dealing your case.",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                      ),
                      Text(patientCondition,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 120,
                        child: Image.asset(
                          conditionImg,
                          fit: BoxFit.fill,
                          height: 60,
                          width: 120,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Text("What is $patientCondition?",
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(conditionText,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ))),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 130,
                  child: Row(children: [
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                height: 120,
                                child: Image.network(
                                  psyImg,
                                  fit: BoxFit.fill,
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                              Column(children: [
                                Row(
                                  children: [
                                    Text(
                                      psychologistName,
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
                                      psyPrice,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.greenAccent,
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    confirmBooking(
                                                      psychologist:
                                                          psychologistId,
                                                    )));
                                      },
                                      child: const Text(
                                        "Book Appoinment",
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
                    ),
                  ]),
                )
              ]),
        ));
  }
}

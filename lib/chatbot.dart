import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:intl/intl.dart';
import 'package:sampleproject/model/user_model.dart';
import 'package:sampleproject/model/result_model.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messageInsert = TextEditingController();
  List<Map> messsages = [];
  List data = [];
  int index = 0;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  resultModel result = resultModel();
  late String name = 'Yogi';
  String condition = "None";
  String psychologist = "None";
  String psychologistId = "123";

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      name = "${loggedInUser.firstName}";
      setState(() {});
    });

    messsages.insert(0, {"data": 0, "message": "To start the chat, Say Hi"});
  }

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/service.json").build();
    DialogFlow dialogflow = DialogFlow(authGoogle: authGoogle, language: "en");
    AIResponse sendData = await dialogflow.detectIntent(name);
    sendData;

    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      if (aiResponse.getListMessage()![0]["text"]["text"][0].toString() ==
          "Based on the test, seems to be like you are suffering from depression. My advice, Dr John Walker is the most suitable psychologist on dealing your case.") {
        condition = "Depression";
        psychologist = "John Walker";
        psychologistId = "PPLAwZscjZMruOhot57TOHYtRl73";
        sendResult();
      }

      if (aiResponse.getListMessage()![0]["text"]["text"][0].toString() ==
          "Based on the test, seems to be like you are suffering from Mental Disorder. My advice, Dr Ram Charan is the most suitable psychologist on dealing your case.") {
        condition = "Mental Disorder";
        psychologist = "Ram Charan";
        psychologistId = "IvWtzkJwLBYdjXzO4pHohNrOxxx2";
        sendResult();
      }

      if (aiResponse.getListMessage()![0]["text"]["text"][0].toString() ==
          "Based on the test, seems to be like you are suffering from anxiety. My advice, Dr Sarah Smith is the most suitable psychologist on dealing your case.") {
        condition = "Anxiety";
        psychologistId = "Qyg1CyDAgqMi2eL6pP0jXmp2GZI2";
        psychologist = "Sarah Smith";
        sendResult();
      }

      if (aiResponse.getListMessage()![0]["text"]["text"][0].toString() ==
          "Based on the test result, seems to be like you are doing fine.") {
        condition = "Good";
        psychologist = "";
      }

      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()![0]["text"]["text"][0].toString()
      });
    });
  }

  sendResult() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DateTime date = DateTime.now();
    final document =
        firebaseFirestore.collection("result").doc(result.resultId);
    result.userId = user!.uid;
    result.resultId = document.id;
    result.condition = condition;
    result.psychologyId = psychologistId;
    result.resultDate = DateFormat('dd/MM/yyyy').format(date);
    result.resultTime = DateFormat('hh:mm a').format(date);
    await document.set(result.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        centerTitle: true,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        elevation: 10,
        title: const Text("Chatbot"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: messsages.length,
                  itemBuilder: (context, index) => chat(
                      messsages[index]["message"].toString(),
                      messsages[index]["data"]))),
          const Divider(
            height: 6.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: messageInsert,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Send your message",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        size: 30.0,
                      ),
                      onPressed: () {
                        if (messageInsert.text.isEmpty) {
                          // ignore: avoid_print
                          print("empty message");
                        } else {
                          setState(() {
                            messsages.insert(
                                0, {"data": 1, "message": messageInsert.text});
                          });
                          response(messageInsert.text);
                          messageInsert.clear();
                        }
                      }),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          )
        ],
      ),
    );
  }

  Widget chat(String message, int data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Bubble(
          radius: const Radius.circular(15.0),
          color: data == 0
              ? Color.fromARGB(255, 227, 19, 127)
              : Colors.orangeAccent,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(
                      data == 0 ? "assets/bot.png" : "assets/user.png"),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'account_screen.dart';
import 'model/user_model.dart';

class changePassword extends StatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  State<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;

  TextEditingController currentPasswordEditingController =
      TextEditingController();
  TextEditingController newPasswordEditingController = TextEditingController();
  TextEditingController comfirmationPasswordEditingController =
      TextEditingController();
  String user_email = "";

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      user_email = "${loggedInUser.email}";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //Current Password field
    final currentPasswordField = TextFormField(
        autofocus: false,
        controller: currentPasswordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is Required for Login");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Password Min. 6 Characters");
          }
        },
        onSaved: (value) {
          newPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Current Password',
            errorText: checkCurrentPasswordValid
                ? null
                : "Please check your current password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    //New Password field
    final newPasswordField = TextFormField(
        autofocus: false,
        controller: newPasswordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is Required for Login");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Password Min. 6 Characters");
          }
        },
        onSaved: (value) {
          newPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'New Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    //Confirm Password field
    final newConfirmPasswordField = TextFormField(
        autofocus: false,
        controller: comfirmationPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (comfirmationPasswordEditingController.text !=
              newPasswordEditingController.text) {
            return "Password did not match.";
          }
        },
        onSaved: (value) {
          comfirmationPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Confirm New Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          checkCurrentPasswordValid = await validateCurrentPassword(
              currentPasswordEditingController.text);

          setState(() {});

          if (formKey.currentState!.validate() && checkCurrentPasswordValid) {
            updateUserPassword(newPasswordEditingController.text);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const account_screen()));
          }
          Fluttertoast.showToast(msg: "Password Succefully Changed");
        },
        child: const Text(
          "Save",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const account_screen()));
        },
        child: const Text(
          "Cancel",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.only(top: 50, bottom: 30),
                color: const Color.fromARGB(255, 35, 90, 190),
                child: Column(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      "Change Password ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                      height: 120,
                      child:
                          Image.asset("assets/user.png", fit: BoxFit.contain)),
                  Column(children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text("${loggedInUser.firstName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ])
                ])),
            Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        currentPasswordField,
                        const SizedBox(height: 20),
                        newPasswordField,
                        const SizedBox(height: 20),
                        newConfirmPasswordField,
                      ],
                    ))),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  cancelButton,
                  const SizedBox(width: 20),
                  saveButton,
                ])
          ]),
    );
  }

  Future<bool> validatePassword(String password) async {
    var authCredentials =
        EmailAuthProvider.credential(email: user_email, password: password);
    try {
      var authResult =
          await user?.reauthenticateWithCredential(authCredentials);
      return authResult!.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await auth.currentUser!;
    firebaseUser.updatePassword(password);
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await validatePassword(password);
  }

  void updateUserPassword(String password) {
    updatePassword(password);
  }
}

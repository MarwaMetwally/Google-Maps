import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber/main.dart';

import 'signupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'mainscreen.dart';

class LogIn extends StatelessWidget {
  static const String id = "login";

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  void signIn(BuildContext context) async {
    //  _auth.signOut();
    print('emailll${email.text}');
    print(password.text);
    final currentUser = await _auth
        .signInWithEmailAndPassword(email: email.text, password: password.text)
        .catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
    if (currentUser != null) {
      userRef.child(currentUser.user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushReplacementNamed(context, MainScreen.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(0.3),
                  BlendMode.dstATop,
                ),
                fit: BoxFit.cover,
                image:
                    AssetImage('assets/images/22816354520_e36b896c37_o.jpg'))),
        child: SingleChildScrollView(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 180),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xfff9a619),
                  child: Icon(
                    Icons.directions_car,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
              ),
              Form(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey),
                          // hintText: "namee",
                          labelStyle: TextStyle()),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          labelStyle: TextStyle()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 150,
                      height: 40,
                      child: RaisedButton(
                        color: Color(0xfff9a619),
                        onPressed: () {
                          signIn(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Text('Login',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                    )
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? Register '),
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, SignUp.id),
                    child: Text(
                      'here',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uber/main.dart';
import 'loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mainscreen.dart';

class SignUp extends StatelessWidget {
  static const String id = "signup";
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void createNewUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final newUser = await _auth
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
        print(e.toString());
      });
      print('successss');
      if (newUser != null) {
        Map userData = {
          "name": name.text.trim(),
          "email": email.text.trim(),
          "phone": phone.text.trim(),
        };
        userRef.child(newUser.user.uid).set(userData);
        Navigator.pushReplacementNamed(context, MainScreen.id);
      }
    } else {}
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
                padding: const EdgeInsets.only(top: 100, bottom: 150),
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
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value.length < 3 || value.isEmpty) {
                              //  Fluttertoast.showToast(msg: 'too short name');
                              return 'Name is too short!';
                            }
                          },
                          controller: name,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Name',
                              hintStyle: TextStyle(color: Colors.grey),
                              // hintText: "namee",
                              labelStyle: TextStyle()),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (!value.contains('@') || value.isEmpty) {
                              return 'Invalid email!';
                            }
                          },
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid phone number!';
                            }
                          },
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Phone',
                              labelStyle: TextStyle()),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.length < 6 || value.isEmpty)
                              return 'password is too short!';
                          },
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
                              //    _submit();
                              createNewUser(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Text('Create Account',
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
                  Text('Already have an account? Login '),
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, LogIn.id),
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

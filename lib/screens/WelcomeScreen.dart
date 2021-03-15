import 'dart:ui';
import 'loginScreen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = "main";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black45.withOpacity(0.5),
            BlendMode.dstATop,
          ),
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/22816354520_e36b896c37_o.jpg',
          ),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ',
                    style: TextStyle(
                        fontSize: 40,
                        color: Color(0xfff9a619),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'fasa7ni',
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'I\'m Driver',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => LogIn()));
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          'I\'m User',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
            //  Image.asset('assets/images/images.png')
            // Form(
            //     child: Column(
            //   children: [
            //     TextFormField(
            //       decoration: InputDecoration(
            //           prefixIcon: Icon(Icons.person),
            //           labelText: 'Name',
            //           labelStyle: TextStyle()),
            //     ),
            //     TextFormField(
            //       decoration: InputDecoration(
            //           prefixIcon: Icon(Icons.security),
            //           labelText: 'Password',
            //           labelStyle: TextStyle()),
            //     )
            //   ],
            // ))
          ],
        ),
      ),
    );
  }
}

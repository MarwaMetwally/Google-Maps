import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/mainscreen.dart';
import 'screens/WelcomeScreen.dart';
import 'screens/signupScreen.dart';
import 'screens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'providers/AppData.dart';
//import 'screens/mainScreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child('users');
//FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Rider App ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //   fontFamily: 'RemachineScript_Personal_Use',
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          // primarySwatch: Colors.grey,
          accentColor: Colors.white,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        routes: {
          SignUp.id: (ctx) => SignUp(),
          LogIn.id: (ctx) => LogIn(),
          MainScreen.id: (ctx) => MainScreen(),
          // WelcomeScreen.id: (ctx) => WelcomeScreen(),

          '/': (ctx) => WelcomeScreen()
        },
        initialRoute: MainScreen.id,
        // home: StreamBuilder(
        //   stream: _auth.userChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.data != null) {
        //       return MainScreen();
        //     } else {
        //       return WelcomeScreen();
        //     }
        //   },
        // )
      ),
    );
  }
}

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/screens/login_screen.dart';
import '../src/screens/onboarding_screen.dart';
import '../src/screens/signup_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // MultiBlocProvider(
        //     providers: [],
        //     child:
        MaterialApp(
      theme: ThemeData(fontFamily: "Nunito-Regular"),
      routes: {
        "/": (context) => OnboardingScreen(),
        "/loginScreen": (context) => LoginScreen(),
        "/signupScreen": (context) => SignupScreen(),
      },
      initialRoute: '/loginScreen',
    );
    // );
  }
}

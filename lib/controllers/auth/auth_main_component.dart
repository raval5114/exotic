import 'package:go_router/go_router.dart';
import 'package:exotic/view/auth/Signin/signin.dart';
import 'package:exotic/view/auth/Signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAuthComponenState extends StatefulWidget {
  const MainAuthComponenState({super.key});

  @override
  State<MainAuthComponenState> createState() => _MainAuthComponenStateState();
}

class _MainAuthComponenStateState extends State<MainAuthComponenState> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or any color you want
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  //Logo Section
  Widget logoSection(String path) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 120),
        child: Image.asset(
          'assets/logo/logo.png',
          height: 86.92559814453125,
          width: 227,
        ),
      ),
    );
  }

  // "Let's get started" button
  Widget registerButton(Widget pathToNavigate) {
    return SizedBox(
      width: double.infinity,
      height: 61,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9747FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          //adding go router to navigate
          context.push('/dynamicRoute', extra: () => pathToNavigate);
        },
        child: Text(
          "Let's get started",
          style: TextStyle(
            fontFamily: 'NunitoSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget loginButton(Widget pathToNavigate) {
    return InkWell(
      onTap: () {
        //adding go router to navigate to
        context.push('/dynamicRoute', extra: () => pathToNavigate);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 167,
            height: 26,
            child: Text(
              "already have an account",
              style: TextStyle(
                fontFamily: 'nunitoSans',
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF9747FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget guestButton() {
    return InkWell(
      onTap: () {
        context.go('/home');
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        child: Text(
          "Continue as Guest",
          style: TextStyle(
            fontFamily: 'nunitoSans',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 80),

            // Logo Section
            logoSection("asset/logo/main.png"),
            const SizedBox(height: 20),

            // Bottom Buttons Section
            Column(
              children: [
                // "Let's get started" button
                registerButton(SignupScreen()),
                const SizedBox(height: 16),

                // Text + Icon Button Row
                loginButton(SigninScreen()),
                
                // Continue as guest
                guestButton(),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

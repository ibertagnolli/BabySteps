import 'package:babysteps/app/pages/user/user_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String? errorMessage;

  void userOrPasswordIncorrect() {
    setState(() {
      errorMessage = "Email or password is incorrect";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: 
        SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/BabyStepsLogo.png',
                      fit: BoxFit.scaleDown)),
              Text(
                'Welcome to BabySteps!',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Text(
                'We\'re glad to see you again!',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: email,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                      focusColor: Theme.of(context).colorScheme.primary,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                      hintText: 'jon.doe@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                    focusColor: Theme.of(context).colorScheme.primary,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.text, password: password.text);

                        String userUid = FirebaseAuth.instance.currentUser!.uid;

                        QuerySnapshot snapshot =
                            await UserDatabaseMethods().getUser(userUid);
                        var doc = snapshot.docs;
                        if (doc.isNotEmpty) {
                          List<dynamic> babyList = doc[0]['baby'];
                          babyList.isNotEmpty
                              ? context.go('/tracking')
                              : context.go('/login/signup/addBaby');
                        } else {
                          context.go('/login/signup/addBaby');
                        }

                        // context.go('/home'); //TODO: add back in when home is interesting
                      } catch (e) {
                        userOrPasswordIncorrect();
                      }
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    )),
              ),
              InkWell(child: const Text('Forgot Password?'), onTap: () => {}),
              InkWell(
                  child: const Text('Don\'t have an account? Sign up here'),
                  onTap: () => context.go('/login/signup')),
            ],
          ),
        ),
      ),
    );
  }
}

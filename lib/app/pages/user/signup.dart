import 'package:flutter/material.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usersName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String? errorMessage;

  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/BabyStepsLogo.png',
                      fit: BoxFit.scaleDown)),
              Text(
                'Welcome to BabySteps',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Text(
                'Create a new account',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.surface),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  controller: usersName,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      focusColor: Theme.of(context).colorScheme.secondary,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      hintText: 'Jon Doe'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: email,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      focusColor: Theme.of(context).colorScheme.secondary,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary)),
                      hintText: 'jon.doe@gmail.com'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    focusColor: Theme.of(context).colorScheme.secondary,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  obscureText: true,
                  controller: confirmPassword,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    focusColor: Theme.of(context).colorScheme.secondary,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16),
                child: FilledButton(
                    onPressed: () async {
                      if (password.text == confirmPassword.text) {
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          if (usersName.text != '') {
                            await user.user?.updateDisplayName(usersName.text);
                            context.go('/login/signup/addBaby');
                          } else {
                            setErrorMessage('Please provide a name!');
                          }
                        } on FirebaseAuthException catch (authError) {
                          switch (authError.code) {
                            case 'email-already-in-use':
                              setErrorMessage("Account already exists!");
                              break;
                            case 'invalid-email':
                              setErrorMessage('Email is not valid');
                              break;
                            case 'weak-password':
                              setErrorMessage(authError.message!);
                              break;
                            default:
                              print(authError.message);
                              setErrorMessage('Error creating account');
                              break;
                          }
                        } catch (e) {}
                      } else {
                        setErrorMessage("Passwords don't match!");
                      }
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    )),
              ),
              InkWell(
                  child: Text('Already have an account? Login here'),
                  onTap: () => context.go('/login/loginPage')),
            ],
          ),
        ),
      ),
    );
  }
}

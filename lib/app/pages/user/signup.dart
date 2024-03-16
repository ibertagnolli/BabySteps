import 'package:email_validator/email_validator.dart';
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

  // The global key uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  String? errorMessage;

  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  /// Creates a User account
  void createAccount() async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);
      
      await user.user?.updateDisplayName(usersName.text);
      context.go('/login/signup/addBaby');
    } 
    on FirebaseAuthException catch (authError) {
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
          setErrorMessage('Error creating account');
          break;
      }
    } catch (e) {
      print("Error creating user account: $e");
    }
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
              
              // Header logo and welcome text
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
              
              // Form fields
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Form(
                  key: _formKey,
                  child: Column( children: <Widget> [
                    
                    // Full Name Field
                    TextFormField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      controller: usersName,
                      maxLength: 60,
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
                          hintText: 'Jon Doe'
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                        return null;
                      },
                    ),
                    
                    // Email Field
                    TextFormField(
                      controller: email,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      maxLength: 25,
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
                          hintText: 'jon.doe@gmail.com'
                      ),
                      validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                    ),
                    
                    // Password Field
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      maxLength: 25,
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
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                      },
                    ),
                    
                    // Confirm Password Field
                    TextFormField(
                      obscureText: true,
                      controller: confirmPassword,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      maxLength: 25,
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
                      validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value != password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                      },
                    ),

                    // Error creating account
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
                
                    // Create Account Button
                    FilledButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          createAccount();
                        }
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary),
                      child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                      )
                    ),
                    
                    // Already have an account
                    InkWell(
                      child: const Text('Already have an account? Login here'),
                      onTap: () => context.go('/login/loginPage')
                    ),
                  ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

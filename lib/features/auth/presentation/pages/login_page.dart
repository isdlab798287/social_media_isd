/*
Login Page
Existing user can login to the app using email and password
if no account, user can create an account
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/presentation/components/my_button.dart';
import 'package:isd_app/features/auth/presentation/components/my_text_field.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:isd_app/features/auth/presentation/pages/forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()?
  togglePages; //callback function to navigate to register page

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //login button pressed
  void login() {
    //login user
    final String email = emailController.text;
    final String password = passwordController.text;

    //auth cubit
    final authCubit = context.read<AuthCubit>();

    //ensure email and password are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      //call the login function from auth cubit
      authCubit.login(email, password);
    } else {
      //show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    //dispose the text controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    // Scaffold widget is the main structure of the app
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        //body
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    Icon(
                      Icons.lock_open_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(height: 50),

                    //welcome text
                    Text(
                      'Welcome back, you\'ve been missed!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 25),

                    //email text field
                    MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),

                    const SizedBox(height: 15),

                    //password text field
                    MyTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    //forgot password text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    //login button
                    MyButton(onTap: login, text: "Sign In"),

                    const SizedBox(height: 25),

                    //not a member? create an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member? ',
                          style: TextStyle(fontSize: 16),
                        ),

                        //register now text
                        GestureDetector(
                          onTap:
                              widget
                                  .togglePages, //call the function to navigate to register page

                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
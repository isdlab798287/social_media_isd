import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/presentation/components/my_button.dart';
import 'package:isd_app/features/auth/presentation/components/my_text_field.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages; //callback function to navigate to login page

  const RegisterPage({
    super.key,
    required this.togglePages,
    });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  //text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //register button pressed
  void register(){
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
  

  final authCubit = context.read<AuthCubit>();

  //ensure fields are not empty
  if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty){
    //ensure password and confirm password match
    if(password == confirmPassword){
      //call the register function from auth cubit
      authCubit.register(name, email, password);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  //fields are empty
  else{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in all fields'),
        duration: Duration(seconds: 2),
      ),
    );
  }
  }

  //dispose text controllers
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  //build ui
  @override
  Widget build(BuildContext context) {
    // Scaffold widget is the main structure of the app
    return Scaffold(
      
      //body
      body:  SafeArea(
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
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              
                    const SizedBox(height: 25,),
              
                    //create account text
                    Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
              
                    const SizedBox(height: 20,),
              
                    //name text field
                    MyTextField(
                      controller: nameController, 
                      hintText: "Name", 
                      obscureText: false,
                    ),
              
                    const SizedBox(height: 20,),
              
                    //email text field
                    MyTextField(
                      controller: emailController, 
                      hintText: "Email", 
                      obscureText: false,
                    ),
              
                    const SizedBox(height: 20,),
              
                    //password text field
                    MyTextField(
                      controller: passwordController, 
                      hintText: "Password", 
                      obscureText: true,
                    ),
              
                    const SizedBox(height: 20,),
              
                    //confirm password text field
              
                    MyTextField(
                      controller: confirmPasswordController, 
                      hintText: "Confirm Password", 
                      obscureText: true,
                    ),
              
                    const SizedBox(height: 20,),
              
                    //login button
                    MyButton(
                      onTap: register,
                      text: "Register",),

          
                        const SizedBox(height: 25),
              
                    //already a member? login now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a member? ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap:
                            widget.togglePages, //call the function to navigate to login page
                         
                          child: const Text(
                            'Login now',
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
    );
  }
}
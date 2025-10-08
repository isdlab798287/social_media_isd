import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:isd_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:isd_app/features/auth/presentation/components/my_button.dart';
import 'package:isd_app/features/auth/presentation/components/my_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void sendResetEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }
    context.read<AuthCubit>().resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AuthInitial) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset link sent! Check your email.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // go back to login
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email address and we’ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyButton(onTap: sendResetEmail, text: "Send Reset Link"),
            ],
          ),
        ),
      ),
    );
  }
}

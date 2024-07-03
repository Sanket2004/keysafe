import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_manager/components/button.dart';
import 'package:password_manager/responsive/responsive.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          _isLoading = true;
        });
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Password reset email send sucessfully.",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff312651),
        ));
        Navigator.popAndPushNamed(context, '/login');
        setState(() {
          _isLoading = false;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        String? message = e.message;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            message!,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff312651),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 242, 243),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ResponsiveWrapper(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff83829a),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff444262),
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xff312651),
                            child: Icon(Icons.lock_outline,
                                size: 40, color: Colors.white),
                          ),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -5,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 30),
                      const Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff312651),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 10),
                      const Text(
                        "Please enter your account’s associated address.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff83829a),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.grey),
                          labelText: 'Your email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Process the forgot password request
                              _onSubmit();
                            }
                          },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Send me email',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                        ).animate().slideX(
                            duration: 500.ms,
                            begin: -10,
                            end: 0,
                            curve: Curves.easeInOut),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

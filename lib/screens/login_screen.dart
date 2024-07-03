import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_manager/components/button.dart';
import 'package:password_manager/responsive/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (credential.user != null) {
        if (credential.user!.emailVerified) {
          Navigator.popAndPushNamed(context, '/home');
        } else {
          // Show verification bottom sheet if email is not verified
          _openVerificationBottomSheet();
        }
      }
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
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'An unexpected error occurred. Please try again later.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff312651),
      ));
    }
  }

  // Function to open bottom sheet for email verification
  void _openVerificationBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Ensure the bottom sheet occupies full height
      builder: (BuildContext context) {
        return SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust for keyboard
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                const Text(
                  'Verify your email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff312651),
                  ),
                ).animate().slideY(
                    duration: 500.ms,
                    begin: 5,
                    end: 0,
                    curve: Curves.easeInOut),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  'We will send you an email where you can verify your email address.',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff83829a),
                  ),
                ).animate().slideY(
                    duration: 500.ms,
                    begin: 5,
                    end: 0,
                    curve: Curves.easeInOut,
                    delay: 100.ms),
                const SizedBox(height: 20),
                Button(
                  onPressed: () async {
                    try {
                      await _firebaseAuth.currentUser!.sendEmailVerification();

                      Navigator.pop(context); // Close bottom sheet

                      // Delay before showing SnackBar
                      await Future.delayed(const Duration(milliseconds: 500));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Verification email sent successfully!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff312651),
                        ),
                      );
                    } on FirebaseException catch (e) {
                      Navigator.pop(context); // Close bottom sheet

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to send verification email: ${e.message}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xff312651),
                        ),
                      );
                    }
                  },
                  child: const Text('Send email'),
                ).animate().slideY(
                    duration: 500.ms,
                    begin: 5,
                    end: 0,
                    curve: Curves.easeInOut,
                    delay: 200.ms),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      // resizeToAvoidBottomInset: true, // Ensure bottom sheet adjusts with keyboard
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 243, 242, 243),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'Login',
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
                        "Please enter your email and password to safely and securely save your passwords.",
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
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.grey),
                          labelText: 'Your email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey.shade500),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20),
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Colors.grey),
                              labelText: 'Your password',
                              labelStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade500),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              suffixIcon: _passwordController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffff7754),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _passwordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -10,
                              end: 0,
                              curve: Curves.easeInOut),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/forgot_pass');
                            },
                            child: const Text(
                              'Forgot password ?',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xffff7754),
                              ),
                            ),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -10,
                              end: 0,
                              curve: Curves.easeInOut),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
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
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account yet ?"),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              'Signup',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xffff7754),
                              ),
                            ),
                          ),
                        ],
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 20),
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

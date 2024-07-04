import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_manager/components/button.dart';
import 'package:password_manager/responsive/responsive.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getAvatarUrl(String name) {
    return 'https://api.dicebear.com/9.x/initials/svg?seed=${Uri.encodeComponent(name)}';
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        try {
          // Store additional user information in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'uid': userCredential.user!.uid,
            'fullName': _fullNameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'gender': _selectedGender,
            'dob': _selectedDate.toIso8601String(),
            'avatar': _getAvatarUrl(_fullNameController.text),
          });
        } catch (e) {
          print(e);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration successful, verify your email to login.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff312651),
          ),
        );
        // Send verification if email is not verified
        userCredential.user!.sendEmailVerification();

        // Navigate to another screen or perform other actions
        Navigator.popAndPushNamed(context, '/login');
        setState(() => _isLoading = false);
      } on FirebaseAuthException catch (e) {
        setState(() => _isLoading = false);
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = e.message ?? 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff312651),
          ),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An error occurred. Please try again.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff312651),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff312651),
                      ),
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 10),
                    const Text(
                      "Explore the app by creating a new account to save your passwords safely and securely",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff83829a),
                      ),
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    if (_fullNameController.text.isNotEmpty)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SvgPicture.network(
                            _getAvatarUrl(_fullNameController.text),
                            height: 125,
                            width: 125,
                            placeholderBuilder: (BuildContext context) =>
                                const SizedBox(
                              height: 48,
                              width: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 10,
                                color: Color(0xffff7754),
                              ),
                            ),
                          ),
                        ),
                      ).animate().slideX(
                            duration: 500.ms,
                            begin: -10,
                            end: 0,
                            curve: Curves.easeInOut,
                          ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(Icons.account_circle_outlined,
                            color: Colors.grey),
                        labelText: 'Full name',
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
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 30),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon:
                            const Icon(Icons.male_outlined, color: Colors.grey),
                        labelText: 'Gender',
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
                      items: <String>['Male', 'Female', 'Other']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(Icons.calendar_month_outlined,
                            color: Colors.grey),
                        labelText: 'Date of Birth',
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
                      controller: TextEditingController(
                          text: "${_selectedDate.toLocal()}".split(' ')[0]),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await _selectDate(context);
                      },
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Colors.grey),
                        labelText: 'Email',
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
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(Icons.phone_outlined,
                            color: Colors.grey),
                        labelText: 'Phone',
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
                          return 'Please enter your phone number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid phone number';
                        }
                        final phoneRegExp = RegExp(r'^[6-9]\d{9}$');
                        if (!phoneRegExp.hasMatch(value)) {
                          return 'Please enter a valid Indian phone number';
                        }
                        return null;
                      },
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(Icons.vpn_key_outlined,
                            color: Colors.grey),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: _passwordController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffff7754),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
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
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
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
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(Icons.vpn_key_outlined,
                            color: Colors.grey),
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: _confirmPasswordController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffff7754),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
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
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
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
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process the registration
                            // String avatarUrl =
                            //     _getAvatarUrl(_fullNameController.text);
                            // print('Selected Avatar: $avatarUrl');
                            _register();
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
                                'Register',
                                style: TextStyle(fontSize: 17),
                              ),
                      ),
                    ).animate().slideX(
                          duration: 500.ms,
                          begin: -10,
                          end: 0,
                          curve: Curves.easeInOut,
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

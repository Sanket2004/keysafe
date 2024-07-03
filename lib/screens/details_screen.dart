import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:convert';
import 'package:password_manager/components/auth_screen.dart';
import 'package:password_manager/responsive/responsive.dart';

class PasswordDetailsScreen extends StatefulWidget {
  const PasswordDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  Map<String, dynamic>? _passwordData;
  bool _isAuthenticated = false;
  String? decodedPassword;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _passwordData ??=
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to view the password',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      _decodePassword();
      _usernameController.text = _passwordData!['username'];
      _passwordController.text = decodedPassword!;
    }

    setState(() {
      _isAuthenticated = authenticated;
    });

    if (!authenticated) {
      Navigator.pop(context); // Go back if authentication fails
    }
  }

  void _decodePassword() {
    final base64Password = _passwordData!['password'];
    decodedPassword = utf8.decode(base64Decode(base64Password));
  }

  @override
  Widget build(BuildContext context) {
    // final Timestamp timestamp = _passwordData!['createdAt'];
    // final DateTime createdAt = timestamp.toDate();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isAuthenticated
          ? _passwordData != null
              ? ResponsiveWrapper(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffe6e4e6),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Image.network(
                                        'https://www.google.com/s2/favicons?sz=64&domain_url=${_passwordData!['website']}',
                                        height: 45,
                                        width: 45,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ).animate().slideX(
                                      duration: 500.ms,
                                      begin: -5,
                                      end: 0,
                                      curve: Curves.easeInOut),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Uri.parse(_passwordData!['website'])
                                                .host
                                                .isEmpty
                                            ? Text(
                                                _passwordData!['website'],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff444262)),
                                              ).animate().slideX(
                                                duration: 500.ms,
                                                begin: -5,
                                                end: 0,
                                                curve: Curves.easeInOut)
                                            : Text(
                                                '${Uri.parse(_passwordData!['website']).host}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff444262)),
                                              ).animate().slideX(
                                                duration: 500.ms,
                                                begin: -5,
                                                end: 0,
                                                curve: Curves.easeInOut),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          _passwordData!['website'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                  255, 138, 137, 138)),
                                        ).animate().slideX(
                                            duration: 500.ms,
                                            begin: -5,
                                            end: 0,
                                            curve: Curves.easeInOut),
                                        // Text(
                                        //   DateFormat.yMMMd().add_jm().format(createdAt),
                                        //   style: const TextStyle(
                                        //       fontSize: 10,
                                        //       fontWeight: FontWeight.w400,
                                        //       color: Color(0xff83829a)),
                                        // )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _usernameController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(20),
                                        hintText: 'Username',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              // topRight: Radius.circular(20),
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              // topRight: Radius.circular(20),
                                            ),
                                            // borderSide: BorderSide(color: Colors.grey.shade500),
                                            borderSide: BorderSide(
                                                color: Colors.transparent)),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 245, 242, 245),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  // Copy username button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 245, 242, 245),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffff7754),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.copy,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          )),
                                      onPressed: () {
                                        // Replace with your copy functionality
                                        Clipboard.setData(ClipboardData(
                                            text: _usernameController.text));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Username copied to clipboard',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Color(0xff312651),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ).animate().slideX(
                                  duration: 500.ms,
                                  begin: -5,
                                  end: 0,
                                  curve: Curves.easeInOut),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _passwordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        hintText: 'Password',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          // borderSide:
                                          //     BorderSide(color: Colors.grey.shade300),
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                            ),
                                            borderSide:
                                                // BorderSide(color: Colors.grey.shade300),
                                                BorderSide(
                                                    color: Colors.transparent)),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            255, 245, 242, 245),
                                        suffixIcon: _passwordController
                                                .text.isEmpty
                                            ? null
                                            : IconButton(
                                                icon: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffff7754),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Icon(
                                                    _passwordVisible
                                                        ? Icons
                                                            .visibility_outlined
                                                        : Icons
                                                            .visibility_off_outlined,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _passwordVisible =
                                                        !_passwordVisible;
                                                  });
                                                },
                                              ),
                                      ),
                                      obscureText: !_passwordVisible,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  // Copy password button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 245, 242, 245),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffff7754),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.copy,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          )),
                                      onPressed: () {
                                        // Replace with your copy functionality
                                        Clipboard.setData(ClipboardData(
                                            text: _passwordController.text));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Password copied to clipboard',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Color(0xff312651),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ).animate().slideX(
                                  duration: 500.ms,
                                  begin: -5,
                                  end: 0,
                                  curve: Curves.easeInOut),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: const Text('No data received').animate().slideX(
                      duration: 500.ms,
                      begin: -5,
                      end: 0,
                      curve: Curves.easeInOut),
                )
          : const Center(
              child: AuthScreen(),
            ),
    );
  }
}

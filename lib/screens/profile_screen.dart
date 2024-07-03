import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_manager/responsive/responsive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  Map<String, dynamic>? _userData;
  bool _editable = false; // Flag to control editing state

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Function to fetch the current user details from Firestore
  Future<void> _fetchUserDetails() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userData = userDoc.data() as Map<String, dynamic>?;
          });
        }
      } catch (e) {
        print('Error fetching user details: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Error fetching user details: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff312651),
        ));
      }
    }
  }

  // Function to update user details in Firestore
  Future<void> _updateUserDetails() async {
    if (_user != null && _userData != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update(_userData!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff312651),
        ));
      } catch (e) {
        print('Error updating user details: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Failed to update profile. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff312651),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_sharp, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextButton(
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(0),
                shadowColor: MaterialStatePropertyAll(Colors.transparent),
                surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
                overlayColor: MaterialStatePropertyAll(Colors.transparent),
                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                foregroundColor: MaterialStatePropertyAll(Colors.transparent),
              ),

              // icon: Icon(_editable ? Icons.save : Icons.edit),
              // onPressed: () {

              // },
              child: _editable
                  ? Text(
                      'done'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ).animate().slideX(
                      duration: 500.ms,
                      begin: -5,
                      end: 0,
                      curve: Curves.easeInOut)
                  : Text(
                      'edit'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.black,
                      ),
                    ).animate().slideX(
                      duration: 500.ms,
                      begin: -12,
                      end: 0,
                      curve: Curves.easeInOut,
                      delay: 500.ms),
              onPressed: () {
                setState(() {
                  if (_editable) {
                    _updateUserDetails(); // Save changes if currently editing
                  }
                  _editable = !_editable; // Toggle edit state
                });
              },
            ),
          ),
        ],
      ),
      body: ResponsiveWrapper(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_userData != null) ...[
                      // Display user avatar if available
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 243, 243),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            _userData!['avatar'] ?? '',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -5,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _userData!['fullName'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff312651),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -5,
                          end: 0,
                          curve: Curves.easeInOut),
                      Text(
                        _userData!['email'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff83829a),
                        ),
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -5,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(height: 15),
                      // Display other user details
                      const Divider(
                        color: Color(0xff83829a),
                        thickness: 0.2,
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -5,
                          end: 0,
                          curve: Curves.easeInOut),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic info'.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'PROFILE PICTURE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ).animate().slideX(
                                        duration: 500.ms,
                                        begin: -5,
                                        end: 0,
                                        curve: Curves.easeInOut),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Profile photo helps to personalise your account',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                    ).animate().slideX(
                                        duration: 500.ms,
                                        begin: -5,
                                        end: 0,
                                        curve: Curves.easeInOut),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  _userData!['avatar'] ?? '',
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ).animate().slideX(
                                  duration: 500.ms,
                                  begin: -12,
                                  end: 0,
                                  curve: Curves.easeInOut),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'NAME',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            initialValue: _userData!['fullName'],
                            readOnly: !_editable,
                            onChanged: (value) {
                              setState(() {
                                _userData!['fullName'] = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              enabled: _editable,
                              hintText: 'Full Name',
                              border: _editable
                                  ? const UnderlineInputBorder()
                                  : InputBorder.none,
                            ),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'EMAIL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            initialValue: _userData!['email'],
                            readOnly: true, // Email should not be editable
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w300),
                              border: InputBorder.none,
                              enabled: false,
                            ),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'PHONE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            initialValue: _userData!['phone'],
                            readOnly: !_editable,
                            onChanged: (value) {
                              setState(() {
                                _userData!['phone'] = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              hintText: 'Phone',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w300),
                              border: _editable
                                  ? const UnderlineInputBorder()
                                  : InputBorder.none,
                              enabled: _editable,
                            ),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: -5,
                              end: 0,
                              curve: Curves.easeInOut),
                        ],
                      ),
                    ],
                    if (_userData == null)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffff7754),
                            strokeWidth: 8,
                          ),
                        ),
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

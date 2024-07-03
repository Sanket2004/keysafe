import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_manager/components/button.dart';

class AddPasswordBottomSheet extends StatefulWidget {
  final VoidCallback onPasswordAdded;

  const AddPasswordBottomSheet({Key? key, required this.onPasswordAdded})
      : super(key: key);

  @override
  _AddPasswordBottomSheetState createState() => _AddPasswordBottomSheetState();
}

class _AddPasswordBottomSheetState extends State<AddPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        // Generate a new document reference with an ID
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('password')
            .doc();

        await docRef.set({
          'id': docRef.id, // Add the ID to the document data
          'website': _websiteController.text.trim(),
          'username': _usernameController.text.trim(),
          'password':
              base64Encode(utf8.encode(_passwordController.text.trim())),
          'createdAt': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password added successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff312651),
          ),
        );

        setState(() => _isLoading = false);
        widget.onPasswordAdded(); // Callback to refresh password list
      } catch (e) {
        setState(() => _isLoading = false);

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
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Add Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff312651),
              ),
            ).animate().slideY(
                duration: 500.ms, begin: 5, end: 0, curve: Curves.easeInOut),
            const SizedBox(height: 30),
            TextFormField(
              controller: _websiteController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Website',
                hintStyle: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: Colors.grey.shade500),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 243, 243, 243),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter website';
                }
                // if (!RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(value)) {
                //   return 'Site name can only contain letters, numbers, dots, and hyphens';
                // }
                if (!value.contains('.')) {
                  return 'Please enter a valid site name';
                }

                return null;
              },
            ).animate().slideY(
                duration: 500.ms, begin: 5, end: 0, curve: Curves.easeInOut),
            const SizedBox(height: 5),
            TextFormField(
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Username',
                hintStyle: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.grey.shade500),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 243, 243, 243),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
            ).animate().slideY(
                duration: 500.ms, begin: 5, end: 0, curve: Curves.easeInOut),
            const SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.go,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: Colors.grey.shade500, fontWeight: FontWeight.w300),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  borderSide: BorderSide(color: Colors.grey.shade500),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 243, 243, 243),
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
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ).animate().slideY(
                duration: 500.ms, begin: 5, end: 0, curve: Curves.easeInOut),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Button(
                onPressed: _onSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ).animate().slideY(
                duration: 500.ms, begin: 5, end: 0, curve: Curves.easeInOut),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

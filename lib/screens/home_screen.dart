import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:password_manager/components/button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:password_manager/responsive/responsive.dart';
import 'package:password_manager/screens/add_password_bottomsheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  Map<String, dynamic>? _userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _passwords = [];
  List<Map<String, dynamic>> _filteredPasswords = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedTag = ''; // Track the selected tag

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

          // Fetch passwords subcollection
          QuerySnapshot passwordSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .collection('password')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .get();

          List<Map<String, dynamic>> passwords = passwordSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          setState(() {
            _passwords = passwords;
            _filteredPasswords = passwords; // Initialize filtered passwords
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

  // Function to show logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: const Color(0xffe6e4e6),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _logout(); // Call logout function
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color(0xff312651), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to handle logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to login screen or any other initial screen
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    } catch (e) {
      print('Error logging out: $e');
      // Show error message or handle gracefully
    }
  }

  String _getFirstName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    return nameParts.isNotEmpty ? nameParts[0] : '';
  }

  // Function to filter passwords based on search query
  void _filterPasswords(String query) {
    List<Map<String, dynamic>> filteredList = _passwords.where((password) {
      String website = password['website'] ?? '';
      String username = password['username'] ?? '';

      return website.toLowerCase().contains(query.toLowerCase()) ||
          username.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredPasswords = filteredList;
    });
  }

  // Menu bottom sheet
  void _openBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      elevation: 0,
      backgroundColor: Colors.grey.shade100,
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Settings',
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
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color(0xffe6e4e6),
                        borderRadius: BorderRadius.circular(22)),
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 211, 210, 211),
                                borderRadius: BorderRadius.circular(15)),
                            child: const FaIcon(
                              FontAwesomeIcons.circleUser,
                              color: Color(0xff444262),
                              size: 18,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Personal details and other details',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ).animate().slideY(
                      duration: 500.ms,
                      begin: 5,
                      end: 0,
                      curve: Curves.easeInOut),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _showLogoutConfirmationDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color(0xffe6e4e6),
                        borderRadius: BorderRadius.circular(22)),
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 211, 210, 211),
                                borderRadius: BorderRadius.circular(15)),
                            child: const FaIcon(
                              FontAwesomeIcons.arrowRightFromBracket,
                              color: Color(0xff444262),
                              size: 18,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Logout',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'This action is irreversible',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        )
                      ],
                    ),
                  ).animate().slideY(
                      duration: 500.ms,
                      begin: 5,
                      end: 0,
                      curve: Curves.easeInOut),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
      // resizeToAvoidBottomInset: true, // Ensure bottom sheet adjusts with keyboard
    );
  }

  void _showAddPasswordBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.grey.shade100,
      builder: (context) {
        return AddPasswordBottomSheet(
          onPasswordAdded: () async {
            // Refresh password list after adding password
            await _fetchUserDetails();
            Navigator.pop(context); // Close the bottom sheet
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: ResponsiveWrapper(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _userData != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _openBottomSheet();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 235, 235, 235),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.barsStaggered,
                                          color: Color(0xff312651),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ).animate().slideX(
                                      duration: 500.ms,
                                      begin: -5,
                                      end: 0,
                                      curve: Curves.easeInOut),
                                  Text(
                                    'KeySafe'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: Color(
                                          0xff444262,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/profile');
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffff7754),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: _userData != null
                                              ? Image.network(
                                                  _userData!['avatar'],
                                                )
                                              : const Text('Loading')),
                                    ),
                                  ).animate().slideX(
                                      duration: 500.ms,
                                      begin: -15,
                                      end: 0,
                                      curve: Curves.easeInOut),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Hello ${_getFirstName(_userData!['fullName'])}',
                                style: const TextStyle(
                                    fontSize: 20, color: Color(0xff312651)),
                              ).animate().slideX(
                                  duration: 500.ms,
                                  begin: -5,
                                  end: 0,
                                  curve: Curves.easeInOut),
                              const SizedBox(height: 5),
                              const Text(
                                'Secure your passwords',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff312651),
                                ),
                              ).animate().slideX(
                                  duration: 500.ms,
                                  begin: -5,
                                  end: 0,
                                  curve: Curves.easeInOut),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _searchController,
                                      onChanged: _filterPasswords,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(18),
                                        hintText: 'What are you looking for ?',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w300),
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                      ),
                                    ).animate().slideX(
                                        duration: 500.ms,
                                        begin: -5,
                                        end: 0,
                                        curve: Curves.easeInOut),
                                  ),
                                  _searchController.text.isNotEmpty
                                      ? const SizedBox(
                                          width: 10,
                                        )
                                      : Container(),
                                  _searchController.text.isNotEmpty
                                      ? SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Button(
                                            onPressed: () {
                                              setState(() {
                                                _searchController.clear();
                                                _filterPasswords('');
                                                _selectedTag = '';
                                              });
                                            },
                                            child: const FaIcon(
                                              FontAwesomeIcons.xmark,
                                              size: 18,
                                            ),
                                          ),
                                        ).animate().slideX(
                                          duration: 500.ms,
                                          begin: 5,
                                          end: 0,
                                          curve: Curves.easeInOut)
                                      : const SizedBox(
                                          width: 0,
                                          height: 0,
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildTag('Google'),
                                    _buildTag('Facebook'),
                                    _buildTag('Microsoft'),
                                    _buildTag('Github'),
                                    _buildTag('Spotify'),
                                  ],
                                ),
                              ).animate().slideX(
                                  duration: 500.ms,
                                  begin: -5,
                                  end: 0,
                                  curve: Curves.easeInOut),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Recently added',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ).animate().slideX(
                                      duration: 500.ms,
                                      begin: -5,
                                      end: 0,
                                      curve: Curves.easeInOut),
                                  IconButton(
                                    onPressed: () {
                                      _showAddPasswordBottomSheet();
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.plus,
                                      size: 17,
                                    ),
                                  ).animate().slideX(
                                      duration: 500.ms,
                                      begin: -10,
                                      end: 0,
                                      curve: Curves.easeInOut),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _filteredPasswords.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _filteredPasswords.length,
                                      itemBuilder: (context, index) {
                                        return Dismissible(
                                          key: UniqueKey(),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (direction) async {
                                            bool confirmDelete =
                                                await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      const Color(0xffe6e4e6),
                                                  title: const Text(
                                                    'Confirm Deletion',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  content: const Text(
                                                    'Are you sure you want to delete this password?',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff83829a)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(
                                                            false); // Return false to indicate cancellation
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop(
                                                            true); // Return true to indicate confirmation
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmDelete) {
                                              // Delete the password from Firestore
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .collection('password')
                                                    .doc(_filteredPasswords[
                                                        index]['id'])
                                                    .delete();

                                                setState(() {
                                                  _filteredPasswords
                                                      .removeAt(index);
                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Password deleted',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Color(0xff312651),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Failed to delete password',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Color(0xff312651),
                                                  ),
                                                );
                                              }
                                            } else {
                                              _fetchUserDetails();
                                            }
                                          },
                                          background: Container(
                                            alignment: Alignment.centerRight,
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.red,
                                            ),
                                            child: const FaIcon(
                                              FontAwesomeIcons.trashCan,
                                              color: Colors.white,
                                              size: 17,
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Navigate to details page using named route
                                              Navigator.pushNamed(
                                                context,
                                                '/password_details',
                                                arguments: _filteredPasswords[
                                                    index], // Pass data to details page if needed
                                              );
                                            },
                                            onLongPress: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Swipe left to delete the password',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Color(0xff312651),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15.0),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(25),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade200),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffe6e4e6),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child: Image.network(
                                                          'https://www.google.com/s2/favicons?sz=64&domain_url=${_filteredPasswords[index]['website']}',
                                                          height: 35,
                                                          width: 35,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Uri.parse(_filteredPasswords[
                                                                          index]
                                                                      [
                                                                      'website'])
                                                                  .host
                                                                  .isNotEmpty
                                                              ? Text(
                                                                  Uri.parse(_filteredPasswords[
                                                                              index]
                                                                          [
                                                                          'website'])
                                                                      .host,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xff312651),
                                                                  ),
                                                                )
                                                              : Text(
                                                                  _filteredPasswords[
                                                                          index]
                                                                      [
                                                                      'website'],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xff312651),
                                                                  ),
                                                                ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            _filteredPasswords[
                                                                        index][
                                                                    'username'] ??
                                                                'Unknown User',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ).animate().slideX(
                                            duration: 500.ms,
                                            begin: -5,
                                            end: 0,
                                            curve: Curves.easeInOut);
                                      },
                                    )
                                  : Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 50),
                                        child: Text(
                                          'No results found',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade500,
                                          ),
                                        ).animate().slideX(
                                            duration: 500.ms,
                                            begin: -5,
                                            end: 0,
                                            curve: Curves.easeInOut),
                                      ),
                                    ),
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
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

  Widget _buildTag(String label) {
    bool isSelected = _selectedTag == label;

    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTag = label;
            _searchController.text = label;
            _filterPasswords(
                label); // Trigger filter with the selected tag label
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff312651) : Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xffe6e4e6),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ));
  }
}

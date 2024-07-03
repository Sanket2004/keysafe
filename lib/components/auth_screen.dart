import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Authentication',
            style: TextStyle(
                fontSize: 22,
                color: Color(0xff312651),
                fontWeight: FontWeight.w700),
          ).animate().slideX(
              duration: 500.ms, begin: -5, end: 0, curve: Curves.easeInOut),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Unlock to see the password',
            style: TextStyle(fontSize: 14, color: Color(0xff83829a)),
          ).animate().slideX(
              duration: 500.ms, begin: -5, end: 0, curve: Curves.easeInOut),
          const SizedBox(
            height: 40,
          ),
          const FaIcon(
            FontAwesomeIcons.fingerprint,
            color: Color(0xffff7754),
            size: 40,
          ).animate().slideX(
              duration: 500.ms, begin: -15, end: 0, curve: Curves.easeInOut),
        ],
      ),
    );
  }
}

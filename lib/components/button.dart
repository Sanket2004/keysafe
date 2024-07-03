import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const Button({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      focusElevation: 0,
      highlightElevation: 0,
      highlightColor: Color(0xffff7754),
      splashColor: Color(0xffff7754),
      color: Color(0xffff7754),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // minWidth: MediaQuery.of(context).size.width,
      onPressed: onPressed,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.maxWidth = 600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:password_manager/components/button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  final String route;
  const SplashScreen({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    const img = "assets/img/greeting.png";
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 242, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: isLandscape
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        img,
                        height: 400,
                        fit: BoxFit.contain,
                      ).animate().slideX(
                          duration: 500.ms,
                          begin: -1,
                          end: 0,
                          delay: 500.ms,
                          curve: Curves.easeInOut),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Save passwords securely',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff312651),
                            ),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: 5,
                              end: 0,
                              delay: 700.ms,
                              curve: Curves.easeInOut),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'All in one place for saving all the password at same loacation',
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff83829a)),
                          ).animate().slideX(
                                duration: 500.ms,
                                begin: 5,
                                end: 0,
                                delay: 900.ms,
                                curve: Curves.easeInOut,
                              ),
                          const SizedBox(
                            height: 25,
                          ),
                          Button(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, route);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Let's Get Started",
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                )
                              ],
                            ),
                          ).animate().slideX(
                              duration: 500.ms,
                              begin: 5,
                              end: 0,
                              delay: 1100.ms,
                              curve: Curves.easeInOut),
                        ],
                      ),
                    ),
                  ).animate().slideX(
                      duration: 500.ms,
                      begin: 1,
                      end: 0,
                      delay: 500.ms,
                      curve: Curves.easeInOut),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 6,
                    child: Image.asset(
                      img,
                      height: 450,
                      fit: BoxFit.cover,
                    ).animate().slideY(
                        duration: 500.ms,
                        begin: -1,
                        end: 0,
                        curve: Curves.easeInOut),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.395,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Save passwords securely',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff312651),
                              ),
                            ).animate().slideY(
                                duration: 500.ms,
                                begin: 5,
                                end: 0,
                                delay: 700.ms,
                                curve: Curves.easeInOut),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'All in one place for saving all the password at same loacation',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff83829a),
                              ),
                            ).animate().slideY(
                                duration: 500.ms,
                                begin: 5,
                                end: 0,
                                delay: 900.ms,
                                curve: Curves.easeInOut),
                            Spacer(),
                            Button(
                              onPressed: () {
                                Navigator.popAndPushNamed(context, route);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Let's Get Started",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 20,
                                  )
                                ],
                              ),
                            ).animate().slideY(
                                duration: 500.ms,
                                begin: 5,
                                end: 0,
                                delay: 1100.ms,
                                curve: Curves.easeInOut),
                          ],
                        ),
                      ),
                    ).animate().slideY(
                        duration: 500.ms,
                        begin: 1,
                        end: 0,
                        delay: 500.ms,
                        curve: Curves.easeInOut),
                  ),
                ],
              ),
      ),
    );
  }
}

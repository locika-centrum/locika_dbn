import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/info_page_scaffold.dart';

class WorkInProgressScreen extends StatelessWidget {
  const WorkInProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'No jo - už na tom makám ...',
      route: '/',
      body: Padding(
        padding: const EdgeInsets.only(top: 64.0, left: 32.0, right: 32.0),
        child: Center(
          child: Lottie.asset('assets/images/animations/programming-error.json'),
        ),
      ),
    );
  }
}

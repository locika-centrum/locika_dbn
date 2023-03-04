import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/scrolling_scaffold.dart';

class WorkInProgressScreen extends StatelessWidget {
  const WorkInProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'No jo - už na tom makám ...',
      body: Padding(
        padding: const EdgeInsets.only(top: 64.0, left: 32.0, right: 32.0),
        child: Center(
          child: Lottie.asset('assets/animations/programming-error.json'),
        ),
      ),
      actionButtonData: [
        ActionButtonData(actionString: 'Zpět do hry'),
      ],
    );
  }
}

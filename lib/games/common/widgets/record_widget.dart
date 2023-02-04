import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_score_base.dart';

class RecordWidget extends StatelessWidget {
  final String title;

  const RecordWidget({this.title = 'Rekord', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                context
                    .select<GameScoreBase, String>((model) => model.highScore),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}

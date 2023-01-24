import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_score_base.dart';

class ScoreWidget extends StatelessWidget {
  final String title;

  const ScoreWidget({this.title = 'Skóre', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                  context.select<GameScoreBase, String>((value) => value.gameScore),
                  style: Theme.of(context).textTheme.titleLarge)
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(''),
        ),
      ],
    );
  }
}

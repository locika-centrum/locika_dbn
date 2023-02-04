import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_score_base.dart';

class ActionWidget extends StatelessWidget {
  const ActionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
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
              child: IconButton(
                onPressed: context.select<GameScoreBase, Function?>(
                            (value) => value.action) ==
                        null
                    ? null
                    : () => context.read<GameScoreBase>().action!(),
                iconSize: 32,
                icon: context
                    .select<GameScoreBase, Icon>((value) => value.actionIcon),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              context
                  .select<GameScoreBase, String>((value) => value.actionTitle),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}

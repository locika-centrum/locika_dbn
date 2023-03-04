import 'package:flutter/material.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/hint_item.dart';

class MostInterestingFactsScreen extends StatelessWidget {
  const MostInterestingFactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'Co děti nejčastěji zajímá',
      closeRoute: '/',
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: const [
            HintItem(
              hintText:
                  'Bojím se doma o sebe a své nejbližší. Cítím strach, vztek, úzkost, lítost…co mám dělat?',
              hintRoute: '/work_in_progress',
              hintIcon: Icons.help_outline,
            ),
            HintItem(
              hintText:
                  'Co s námi/se mnou bude, když o situaci doma někomu řeknu',
              hintRoute: '/work_in_progress',
              hintIcon: Icons.help_outline,
            ),
            HintItem(
              hintText: 'Můžu za to, co se u nás doma děje, já?',
              hintRoute: '/work_in_progress',
              hintIcon: Icons.help_outline,
            ),
          ],
        ),
      ),
      actionButtonData: [
        ActionButtonData(
          actionString: 'Chci chatovat',
          actionRoute: '/login',
          actionBackgroundColor: const Color(0xff0567ad),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/info_page_scaffold.dart';
import '../widgets/menu_action_panel.dart';

class ChatMenuScreen extends StatelessWidget {
  const ChatMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'Neboj se, ozvi se.',
      route: '/',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MenuActionPanel(
              title: 'Můžeš s námi chatovoat',
              text:
                  'Žádný problém není tak malý nebo tak velký, aby se nedal řešit. Jsme tady pro tebe.',
              hintText: 'Jak chat funguje',
              hintRoute: '/work_in_progress',
              actionButton: OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48.0)),
                child: Text(
                  'Chci chatovat',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            MenuActionPanel(
              title: 'Potřebuješ rychlou pomoc?',
              text:
                  'Stačí kdykoli stisknout žluté tlačítko  “SOS Pomoc” a spojíš se přímo s Policíí ČR.',
              hintText: 'Kdy volat policii',
              hintRoute: '/work_in_progress',
              actionButton: OutlinedButton(
                onPressed: () => context.go('/work_in_progress'),
                style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xfffebd49),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48.0)),
                child: Text(
                  'SOS pomoc',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

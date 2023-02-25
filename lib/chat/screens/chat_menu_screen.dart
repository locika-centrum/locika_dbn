import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/info_page_scaffold.dart';
import '../widgets/menu_action_panel.dart';

class ChatMenuScreen extends StatelessWidget {
  const ChatMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      route: '/',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Neboj se, ozvi se.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            MenuActionPanel(
              title: 'Můžeš s námi chatovoat',
              text:
                  'Žádný problém není tak malý nebo tak velký, aby se nedal řešit. Jsme tady pro tebe.',
              backgroundColor: const Color(0xff0567ad).withOpacity(0.15),
              hintText: 'Jak chat funguje',
              hintRoute: '/work_in_progress',
              actionButton: OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xff0567ad),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48.0),
                  shape: const StadiumBorder(),
                ),
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
              backgroundColor: const Color(0xfffdbc47).withOpacity(0.15),
              hintText: 'Kdy volat policii',
              hintRoute: '/about_call_police',
              actionButton: OutlinedButton(
                onPressed: () => context.go('/work_in_progress'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xfffebd49),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48.0),
                  shape: const StadiumBorder(),
                ),
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
        /*
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Neboj se, ozvi se.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
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
              hintRoute: '/about_call_police',
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
        */
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logging/logging.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/bullet_text.dart';
import '../widgets/call_bottom_sheeet.dart';
import '../widgets/menu_action_panel.dart';

Logger _log = Logger('about_chat_screen.dart');

class AboutChatScreen extends StatelessWidget {
  const AboutChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'O Chatu',
      closeRoute: '/chat',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/about_chat2.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  const BulletText(
                    text: 'Necítíš se doma bezpečně?',
                    color: BulletColor.blue,
                  ),
                  const BulletText(
                    text: 'Máš strach o sebe nebo své blízké?',
                    color: BulletColor.green,
                  ),
                  const BulletText(
                    text: 'Často se u vás doma křičí, vyhrožuje?',
                    color: BulletColor.yellow,
                  ),
                  const BulletText(
                    text:
                        'Ubližují si tvoji blízcí navzájem nebo přímo ubližují tobě?',
                    color: BulletColor.red,
                  ),
                  Markdown(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: snapshot.data!,
                    styleSheet: MarkdownStyleSheet(
                      h1: Theme.of(context).textTheme.displayLarge,
                      p: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  MenuActionPanel(
                    title: 'Můžeš s námi chatovat',
                    text:
                    'Žádný problém není tak malý nebo tak velký, aby se nedal řešit.\nJsme tady pro tebe ve všední dny od 13:00 do 17:30 a v sobotu od 9:00 do 13:30.',
                    backgroundColor: const Color(0xff0567ad).withOpacity(0.15),
                    hintText: 'Jak chat funguje',
                    hintRoute: '/how_chat_works',
                    actionButton: OutlinedButton(
                      onPressed: () => context.go('/chat'),
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
                      onPressed: () => CallBottomSheet.showDialog(context, '/about_chat'),
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
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

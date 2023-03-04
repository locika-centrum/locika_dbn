import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/bullet_text.dart';

class ChatIntroScreen extends StatelessWidget {
  const ChatIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'Jsme tu pro tebe',
      closeRoute: '/',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/about_chat.md'),
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
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      actionButtonData: [
        ActionButtonData(
          actionString: 'Přihlásit se',
          actionRoute: '/login',
        ),
        ActionButtonData(
          actionString: 'Ještě nemám účet',
          actionRoute: '/sign_up',
          actionColor: Colors.black,
          actionBackgroundColor: Colors.white,
        )
      ],
    );
  }
}

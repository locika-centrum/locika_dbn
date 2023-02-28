import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/scrolling_scaffold.dart';

class ChatIntroScreen extends StatelessWidget {
  const ChatIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      closeRoute: '/',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/about_chat.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data!,
              styleSheet: MarkdownStyleSheet(
                h1: Theme.of(context).textTheme.displayLarge,
                p: Theme.of(context).textTheme.displaySmall,
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      actionRoute: '/chat_menu',
      actionString: 'Pokračovat',
    );
  }
}

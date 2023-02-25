import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/info_page_scaffold.dart';

class ChatIntroScreen extends StatelessWidget {
  const ChatIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      route: '/',
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
      bottomButton: OutlinedButton(
        onPressed: () => context.go('/chat_menu'),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48.0),
          shape: const StadiumBorder(),
        ),
        child: Text(
          'Pokračovat',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

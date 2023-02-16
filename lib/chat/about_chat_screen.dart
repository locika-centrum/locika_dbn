import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../widgets/info_page_scaffold.dart';

Logger _log = Logger('about_chat_screen.dart');

class AboutChatScreen extends StatelessWidget {
  const AboutChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'O chatu',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/about_chat.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            _log.finest('Snapshot data: ${snapshot.data}');
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
    );
  }
}

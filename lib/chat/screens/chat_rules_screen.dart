import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:locika_dbn_test/chat/widgets/redirect_button.dart';

import '../../widgets/scrolling_scaffold.dart';

class ChatRulesScreen extends StatelessWidget {
  const ChatRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      closeRoute: '/',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/chat_rules.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Markdown(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      data: snapshot.data!,
                      styleSheet: MarkdownStyleSheet(
                        h1: Theme.of(context).textTheme.displayLarge,
                        p: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RedirectButton(
                          label: 'Chci chatovat',
                          route: '/login',
                          backgroundColor: Color(0xff0567ad),
                        ),
                      ),
                    ),
                  ],
                ),
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

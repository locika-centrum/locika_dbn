import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/scrolling_scaffold.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      closeRoute: '/chat',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/email.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Markdown(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: snapshot.data!,
                    styleSheet: MarkdownStyleSheet(
                      h1: Theme.of(context).textTheme.displayLarge,
                      p: Theme.of(context).textTheme.displaySmall,
                      h6Align: WrapAlignment.center,
                      tableColumnWidth: const IntrinsicColumnWidth(),
                      tableBody: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tvoje e-mailová adresa',
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      minLines: 6,
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tvoje zpráva',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
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
          actionString: 'Odeslat e-mail',
          actionRoute: '/work_in_progress',
          actionBackgroundColor: const Color(0xff0567ad),
        )
      ],
    );
  }
}

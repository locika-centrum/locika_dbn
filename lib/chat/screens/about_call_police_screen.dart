import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/info_page_scaffold.dart';
import '../../widgets/scrolling_scaffold.dart';
import '../widgets/redirect_button.dart';

class AboutCallPoliceScreen extends StatelessWidget {
  const AboutCallPoliceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      closeRoute: '/',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/when_to_call_police.md'),
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
                        h6Align: WrapAlignment.center,
                        tableColumnWidth: const IntrinsicColumnWidth(),
                        tableBody: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RedirectButton(
                          label: 'SOS Pomoc',
                          route: '/work_in_progress',
                          buttonColor: Colors.black,
                          backgroundColor: Color(0xfffdbc47),
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

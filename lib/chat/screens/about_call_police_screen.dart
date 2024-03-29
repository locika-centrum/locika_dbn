import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/call_bottom_sheeet.dart';
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
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RedirectButton(
                          label: 'SOS Pomoc',
                          callback: () => CallBottomSheet.showDialog(context, '/about_call_police'),
                          buttonColor: Colors.black,
                          backgroundColor: const Color(0xfffdbc47),
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

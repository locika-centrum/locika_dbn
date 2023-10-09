import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/hint_item.dart';
import '../widgets/redirect_button.dart';

class MostInterestingFactsScreen extends StatelessWidget {
  const MostInterestingFactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'Co děti nejčastěji zajímá',
      closeRoute: '/how_chat_works',
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            HintItem(
              hintText:
                  'Bojím se, zlobím se, chce se mi brečet... Co mám dělat?',
              hintIcon: Icons.help_outline,
              hintCallback: () => showDialog(context, 'interesting01.md'),
            ),
            HintItem(
              hintText:
                  'Co se stane, když o tom, co se děje řeknu?',
              hintIcon: Icons.help_outline,
              hintCallback: () => showDialog(context, 'interesting02.md'),
            ),
            HintItem(
              hintText: 'Můžu za to, co se u nás doma děje, já?',
              hintIcon: Icons.help_outline,
              hintCallback: () => showDialog(context, 'interesting03.md'),
            ),
          ],
        ),
      ),
      actionButtonData: [
        ActionButtonData(
          actionString: 'Chci chatovat',
          actionRoute: '/login',
          actionBackgroundColor: const Color(0xff0567ad),
        )
      ],
    );
  }

  void showDialog(BuildContext context, String asset) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              16.0,
            ),
          ),
        ),
        builder: (BuildContext context) {
          return FutureBuilder(
              future: rootBundle.loadString('assets/texts/$asset'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
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
                        const SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0,),
                            child: RedirectButton(
                              label: 'Chci chatovat',
                              route: '/chat',
                              backgroundColor: Color(0xff0567ad),
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
              });
        });
  }
}

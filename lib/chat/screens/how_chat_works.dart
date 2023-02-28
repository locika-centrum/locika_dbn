import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/scrolling_scaffold.dart';

class HowChatWorks extends StatelessWidget {
  const HowChatWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      closeRoute: '/',
      body: FutureBuilder(
        future: rootBundle.loadString('assets/texts/how_chat_works.md'),
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
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff0567ad).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Text(
                            'Zajímá tě víc?',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: InkWell(
                              onTap: () => context.go('/chat_rules'),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.rule,
                                  ),
                                  Text(
                                    '  Pravidla chatu',
                                    style:
                                        Theme.of(context).textTheme.displaySmall,
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: InkWell(
                              onTap: () => context.go('/work_in_progress'),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.help_outline,
                                  ),
                                  Text(
                                    '  Co děti nejčastěji zajímá',
                                    style:
                                        Theme.of(context).textTheme.displaySmall,
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
      actionRoute: '/login',
      actionString: 'Chci chatovat',
      actionBackgroundColor: const Color(0xff0567ad),
    );
  }
}

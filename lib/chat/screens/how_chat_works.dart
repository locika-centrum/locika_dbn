import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/bullet_text.dart';
import '../widgets/menu_action_panel.dart';

class HowChatWorks extends StatefulWidget {
  const HowChatWorks({Key? key}) : super(key: key);

  @override
  State<HowChatWorks> createState() => _HowChatWorksState();
}

class _HowChatWorksState extends State<HowChatWorks> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: 'UkZqcT2XuBM',
        flags: const YoutubePlayerFlags(
          showLiveFullscreenButton: false,
        ))
      ..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'Jak chat funguje',
      closeRoute: '/about_chat',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Text(
                'Neboj se, ozvi se',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: YoutubePlayer(
                  controller: _controller,
                ),
              ),
            ),
            const BulletText(
              text:
                  'Chat je pro děti do 18 let, je anonymní a můžeš se k němu kdykoliv vrátit. ',
              color: BulletColor.blue,
            ),
            const BulletText(
              text:
                  'Během jednoho dne spolu můžeme chatovat nejdéle 90 minut. ',
              color: BulletColor.green,
            ),
            MenuActionPanel(
                title: 'Zajímá tě víc?',
                backgroundColor: const Color(0xff0567ad).withOpacity(0.15),
                hints: [
                  ActionHintData(
                    hintText: 'Pravidla chatu',
                    hintRoute: '/chat_rules',
                  ),
                  ActionHintData(
                    hintText: 'Co děti nejčastěji zajímá',
                    hintRoute: '/most_interesting_facts',
                  ),
                ]),
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
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/bullet_text.dart';
import '../widgets/menu_action_panel.dart';

class HowChatWorks extends StatefulWidget {
  const HowChatWorks({Key? key}) : super(key: key);

  @override
  State<HowChatWorks> createState() => _HowChatWorksState();
}

class _HowChatWorksState extends State<HowChatWorks> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/locika_clip.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {}));
    //_controller.play();
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
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      _ControlsOverlay(controller: _controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
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

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

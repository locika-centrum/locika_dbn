import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../settings/model/settings_data.dart';
import '../widgets/app_bar_chat.dart';

import './models/chat_response.dart';
import './models/chat_room.dart';
import './services/neziskovky_parser.dart';
import 'models/chat_message.dart';
import 'models/session_data.dart';

Logger _log = Logger('chat_screen.dart');

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Timer? timer;
  String timestamp = '';
  StreamController<List<ChatMessage>> controller =
      StreamController<List<ChatMessage>>();
  ScrollController listScrollController = ScrollController();
  int timerStopCounter = 2 * 60 * 60 ~/ 2; // two hours

  Future<ChatRoom?> fetchChat() async {
    final random = Random();
    Cookie? cookie = context.read<SessionData>().cookie;
    ChatRoom room;
    ChatResponse response;

    // Get available chats
    ChatResponse<ChatRoom> result = await getChatRooms(cookie: cookie);

    _log.fine(
        'ChatRooms: ${result.data.length}, response: ${result.statusCode}, message: ${result.message}');
    if (result.data.isEmpty) return null;
    room = result.data[random.nextInt(result.data.length)];

    // Login to chat
    response = await initChat(advisorID: room.advisorID!, cookie: cookie);
    _log.fine(
        'initChat: ${response.data}, response_code: ${response.statusCode}');

    // Subscribe to periodic chat refresh
    timer ??= Timer.periodic(
      const Duration(seconds: 2),
      (Timer t) async {
        _log.fine('Timer {counter: $timerStopCounter}, timestamp: $timestamp}');

        String newTimestamp =
            await getChatTimestamp(chatID: response.chatID!, cookie: cookie!);

        if (timestamp != newTimestamp) {
          timestamp = newTimestamp;

          ChatResponse<ChatMessage> result = await getChatMessages(
              advisorID: room.advisorID!,
              chatID: response.chatID!,
              cookie: cookie,
              nickName: context.read<SettingsData>().nickName);
          context.read<SessionData>().cookie = result.cookie;

          controller.add(result.data);
          Future.delayed(const Duration(seconds: 1), () {
            listScrollController.jumpTo(
                listScrollController.position.maxScrollExtent);
          });
        }

        // Assurance of stopping after defined time
        timerStopCounter--;
        if (timerStopCounter <= 0) t.cancel();
      },
    );

    return room;
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(
        route: '/',
        showAboutLink: true,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xfffebd49),
            child: InkWell(
              onTap: () => context.go('/work_in_progress'),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.call,
                    ),
                    Text(
                      '  SOS Pomoc',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                    )
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: fetchChat(),
            builder: (BuildContext context, AsyncSnapshot<ChatRoom?> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DateChip(
                          date: DateTime.now(),
                        ),
                        Center(
                          child: Text(
                            'Chat byl v pořádku otevřen,',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'vyčkejte než se připojí Pracovník chatu.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                        StreamBuilder(
                          stream: controller.stream,
                          builder: (BuildContext ctx,
                              AsyncSnapshot<List<ChatMessage>> snapshot) {
                            return snapshot.data != null
                                ? ListView.builder(
                                    controller: listScrollController,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      // return Text('$index');
                                      if (index < 2) return Container();
                                      bool isSender = snapshot
                                              .data![index].sysMessage ==
                                          context.read<SettingsData>().nickName;

                                      return BubbleSpecialThree(
                                        isSender: isSender,
                                        text: snapshot.data![index].message,
                                        tail: true,
                                        color: isSender
                                            ? const Color(0xff448af7)
                                            : const Color(0xffe9e9eb),
                                        textStyle: isSender
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: Colors.white)
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/face_not_available.png',
                      width: 150,
                    ),
                    DateChip(
                      date: DateTime.now(),
                    ),
                    const BubbleSpecialThree(
                      text:
                          'Náš poradce není bohužel aktuálně k dispozici. Zkus to znovu později nebo nám napiš mail.',
                      isSender: false,
                      tail: true,
                      color: Color(0xffe9e9eb),
                    ),
                    const BubbleSpecialThree(
                      text:
                          'Je to akutní?\n- Zavolej na Linku bezpečí nebo Dětského krizového centra.\n- Použij SOS tlačítko',
                      isSender: false,
                      tail: true,
                      color: Color(0xffe9e9eb),
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.exit_to_app),
                      Text(
                        '  Zpět do hry',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

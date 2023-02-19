import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:locika_dbn_test/chat/widgets/chat_history.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../settings/model/settings_data.dart';
import '../widgets/app_bar_chat.dart';
import './widgets/advisor_not_available.dart';
import './widgets/date_chip.dart';

import './models/chat_response.dart';
import './models/chat_room.dart';
import './services/neziskovky_parser.dart';
import './models/chat_message.dart';
import './models/session_data.dart';

Logger _log = Logger('chat_screen.dart');

class ChatScreen extends StatefulWidget {
  static const int timerFindChatRetrySeconds = 10;
  static const int timerGetMessageRetrySeconds = 2;

  final Cookie cookie;

  const ChatScreen({
    Key? key,
    required this.cookie,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  Duration lastElapsed = Duration.zero;

  final random = Random();

  ChatRoom? room;
  DateTime? chatStart;

  String timestamp = '';

  ChatResponse<ChatMessage>? chatHistory;
  final ScrollController scrollController = ScrollController();

  @override
  initState() {
    initializeDateFormatting();

    ticker = createTicker((Duration elapsed) async {
      if (elapsed.inHours >= 2) {
        ticker.stop();
      }

      if (room == null) {
        // TODO Manage end of time

        // Retrieve room
        if (lastElapsed == Duration.zero ||
            elapsed.inSeconds - lastElapsed.inSeconds >=
                ChatScreen.timerFindChatRetrySeconds) {
          lastElapsed = elapsed;

          _log.fine('Tick ROOM: ${elapsed.inSeconds}');
          ChatResponse<ChatRoom> result = await getChatRooms(
            cookie: widget.cookie,
          );

          if (chatStart == null) setState(() => chatStart = DateTime.now());
          if (result.data.isNotEmpty) {
            ChatRoom selectedRoom =
                result.data[random.nextInt(result.data.length)];

            if (context.mounted) {
              ChatResponse response = await initChat(
                advisorID: selectedRoom.advisorID!,
                cookie: widget.cookie,
              );
              if (response.chatID != null) {
                selectedRoom.chatID = response.chatID;
                _log.fine('Successful chat initialization: $selectedRoom');

                setState(() => room = selectedRoom);
              }
            }
          }
        }
      } else {
        // TODO Manage end of time

        // If room is found, retrieve chat
        if (elapsed.inSeconds - lastElapsed.inSeconds >=
            ChatScreen.timerGetMessageRetrySeconds) {
          lastElapsed = elapsed;

          String newTimestamp = await getChatTimestamp(
            chatID: room!.chatID!,
            cookie: widget.cookie,
          );
          _log.fine(
              'Tick MESSAGE: ${elapsed.inSeconds} : ${timestamp != newTimestamp ? 'UPDATE' : 'KEEP'} : for $room');

          if (timestamp != newTimestamp) {
            timestamp = newTimestamp;

            if (context.mounted) {
              chatHistory = await getChatMessages(
                  advisorID: room!.advisorID!,
                  chatID: room!.chatID!,
                  cookie: widget.cookie,
                  nickName: context.read<SettingsData>().nickName);
              _log.fine('Chat refreshed');

              setState(() {});

              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                },
              );
            }
          }
        }
      }
    });
    ticker.start();

    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();

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
          if (chatStart == null) const CircularProgressIndicator(),
          if (chatStart != null && room == null)
            Expanded(child: AdvisorNotAvailable(date: chatStart!)),
          if (chatStart != null && room != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      DateChip(
                        date: chatStart!,
                        includeTime: true,
                      ),
                      Center(
                        child: Text(
                          'Chat byl v pořádku otevřen,',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'vyčkejte než se připojí Pracovník chatu.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                      if (chatHistory != null)
                        ChatHistory(data: chatHistory!.data),
                    ],
                  ),
                ),
              ),
            ),
          if (chatStart != null && room != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: MessageBar(
                onSend: (String message) => postMessage(
                  text: message,
                  chatID: room!.chatID!,
                  cookie: widget.cookie,
                ),
              ),
            ),
          if (chatStart != null)
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
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
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

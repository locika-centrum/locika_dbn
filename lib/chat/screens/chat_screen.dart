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

import '../../settings/model/settings_data.dart';
import '../../widgets/app_bar_chat.dart';
import '../widgets/advisor_not_available.dart';
import '../widgets/call_bottom_sheeet.dart';
import '../widgets/date_chip.dart';

import '../models/chat_response.dart';
import '../models/chat_room.dart';
import '../services/neziskovky_parser.dart';
import '../models/chat_message.dart';
import '../widgets/redirect_button.dart';

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
  bool online = false;

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
        if (lastElapsed == Duration.zero) {
          context.read<SettingsData>().firstLogin = false;
        }

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
          if (result.statusCode == HttpStatus.ok && result.data.isNotEmpty) {
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
        // If room is found, retrieve chat
        if (elapsed.inSeconds - lastElapsed.inSeconds >=
            ChatScreen.timerGetMessageRetrySeconds) {
          lastElapsed = elapsed;

          String newTimestamp = await getChatTimestamp(
            chatID: room!.chatID!,
            cookie: widget.cookie,
          );
          _log.finest(
              '*** New stamp: $newTimestamp, empty: ${newTimestamp != ''}');
          if (newTimestamp != '') {
            if (!online) {
              setState(() => online = true);
            }

            if (timestamp != newTimestamp) {
              timestamp = newTimestamp;

              if (context.mounted) {
                chatHistory = await getChatMessages(
                    advisorID: room!.advisorID!,
                    chatID: room!.chatID!,
                    cookie: widget.cookie,
                    nickName: context.read<SettingsData>().nickName);
                _log.fine('Chat refreshed');
                setState(() => {});

                Future.delayed(
                  const Duration(milliseconds: 200),
                  () {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  },
                );
              }
            }
          } else {
            setState(() => online = false);
          }
          _log.fine(
              'Tick MESSAGE: {elapsed: ${elapsed.inSeconds}, online: $online, chatStart: $chatStart, room: $room}');
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const ChatAppBar(
          showAboutLink: true,
        ),
        backgroundColor: const Color(0xffd9e8f3),
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              'assets/images/chat_background.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            )),
            Column(
              children: [
                Container(
                  color: const Color(0xfffebd49),
                  child: InkWell(
                    onTap: () => CallBottomSheet.showDialog(context, '/chat'),
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
                  Expanded(
                    child: AdvisorNotAvailable(date: chatStart!),
                  ),
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
                              date: chatHistory == null
                                  ? chatStart!
                                  : chatHistory!.data.first.dateTime,
                              includeTime: true,
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
                            const SizedBox(
                              height: 8,
                            ),
                            if (chatHistory != null)
                              ChatHistory(data: chatHistory!.data),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (online && chatStart != null && room != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MessageBar(
                      onSend: (String message) => postMessage(
                        text: message,
                        chatID: room!.chatID!,
                        cookie: widget.cookie,
                      ),
                      messageBarColor: Colors.transparent,
                    ),
                  ),
                if (chatStart != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: Column(
                        children: [
                          if (room == null)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: RedirectButton(
                                label: 'Napsat e-mail',
                                route: '/email',
                                backgroundColor: Color(0xff0567ad),
                              ),
                            ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: RedirectButton(
                              label: '  Zpět do hry',
                              route: '/',
                              labelIcon: Icons.exit_to_app,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

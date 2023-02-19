import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/model/settings_data.dart';
import '../models/chat_message.dart';

class ChatHistory extends StatelessWidget {
  final List<ChatMessage> data;
  final DateTime startTime;

  ChatHistory({Key? key, required this.data, DateTime? startTime})
      : startTime = startTime ?? DateTime.now(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        if (index < 2) return Container();

        bool isSender =
            data[index].sysMessage == context.read<SettingsData>().nickName;

        return BubbleSpecialThree(
          isSender: isSender,
          text: data[index].message,
          tail: true,
          color: isSender ? const Color(0xff448af7) : const Color(0xffe9e9eb),
          textStyle: isSender
              ? Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white)
              : Theme.of(context).textTheme.bodyMedium!,
        );
      },
    );
  }
}

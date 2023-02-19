import 'package:flutter/material.dart';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';

import './date_chip.dart';

class AdvisorNotAvailable extends StatelessWidget {
  final DateTime date;

  const AdvisorNotAvailable({
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO this should not be hardcoded - but then we need DB on server
    DateTime now = DateTime.now();
    if (now.weekday == DateTime.saturday ||
        now.weekday == DateTime.sunday ||
        now.hour < 13 ||
        now.hour > 16) {
      return Column(
        children: [
          Image.asset(
            'assets/images/face_offline.png',
            width: 150,
          ),
          DateChip(
            date: date,
            includeTime: true,
          ),
          const BubbleSpecialThree(
            text:
                'Momentálně jsou naši poradci offline.\nJsme tu pro tebe od pondělí do pátku od 13 do 17 hodin.\nPřijď později nebo nám pošli mail.',
            isSender: false,
            tail: true,
            color: Color(0xffe9e9eb),
          ),
          const BubbleSpecialThree(
            text:
                'Je to akutní?\nZavolej na Linku bezpečí nebo Dětského krizového centra.\nPoužij SOS tlačítko',
            isSender: false,
            tail: true,
            color: Color(0xffe9e9eb),
          ),
        ],
      );
    }

    return Column(
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
    );
  }
}

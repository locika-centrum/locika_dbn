import 'package:flutter/material.dart';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';

import './date_chip.dart';

class AdvisorNotAvailable extends StatelessWidget {
  final DateTime date;

  const AdvisorNotAvailable({
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    if (now.weekday == DateTime.saturday ||
        now.weekday == DateTime.sunday ||
        now.hour < 13 ||
        now.hour > 16) {
      return Column(
        children: [
          DateChip(
            date: date,
            includeTime: true,
          ),
          BubbleNormalImage(
            id: 'id001',
            image: Image.asset(
              'assets/images/face_offline.png',
              width: 120,
            ),
            isSender: false,
            tail: true,
            color: Colors.white,
          ),
          const BubbleSpecialThree(
            text:
                'Bohužel momentálně jsou všichni naši poradci offline.\nPřicházíš pravděpodobně mimo provozní dobu naší poradny.\nJejí aktuální podobu najdeš na https://locika.neziskovky.com/\nPokud s někým potřebuješ mluvit, můžeš se vrátit v době, kdy je CHAT otevřený, kontaktovat některou z nonstop krizových linek (proklik) nebo nám můžeš poslat zprávu (proklik na mail) a my se ti ozveme.',
            isSender: false,
            tail: true,
            color: Colors.white,
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

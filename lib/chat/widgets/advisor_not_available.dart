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

    if ((now.weekday == DateTime.saturday &&
          (now.hour < 9 ||
              now.hour > 14 ||
              (now.hour > 13 && now.minute > 30)))  ||
        now.weekday == DateTime.sunday ||
        now.hour < 13 ||
        now.hour > 18 ||
        (now.hour == 17 && now.minute > 30)) {
      return Column(
        children: [
          DateChip(
            date: date,
            includeTime: true,
          ),
          BubbleNormalImage(
            id: 'id001',
            image: Image.asset(
              'assets/images/emoji01.png',
              width: 120,
            ),
            isSender: false,
            tail: true,
            color: Colors.white,
          ),
          const BubbleSpecialThree(
            text:
                'Je nám líto, ale všichni poradci jsou offline. Přicházíš pravděpodobně mimo provozní dobu naší poradny. Její aktuální podobu najdeš na locika.neziskovky.cz',
            isSender: false,
            tail: true,
            color: Colors.white,
          ),
          const BubbleSpecialThree(
            text: 'Pokud se potřebuješ svěřit, volej Linku bezpečí (116 111) nebo Dětské krizové centrum - 777 715 215. Nebo nám napiš e-mail a my se ti co nejdříve ozveme.',
            isSender: false,
            tail: true,
            color: Colors.white,
          )
        ],
      );
    }

    return Column(
      children: [
        Image.asset(
          'assets/images/emoji02.png',
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
              'Je to akutní?\n- Zavolej na Linku bezpečí (116 111) nebo Dětské krizové centrum - 777 715 215\n- Použij SOS tlačítko',
          isSender: false,
          tail: true,
          color: Color(0xffe9e9eb),
        ),
      ],
    );
  }
}

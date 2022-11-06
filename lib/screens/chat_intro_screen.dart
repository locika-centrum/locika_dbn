import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/app_bar_chat.dart';

class ChatIntroScreen extends StatelessWidget {
  const ChatIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jsme tu pro tebe',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text('\nNecítíš se doma bezpečně?'),
            const Text('\nMáš strach o sebe nebo své blízké?'),
            const Text('\nČasto se u vás doma křičí, vyhrožuje?'),
            const Text(
                '\nUbližují si tvoji blízcí navzájem nebo přímo ubližují tobě?'),
            Image.asset('assets/images/kluk_pod_posteli.png'),
            const Text(
              'Neboj se, nejsi v tom sám/a.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('\nNení to tvoje vina. Násilí doma není v pořádku. '),
            const Text(
                '\nJe důležité, abys o tom s někým mluvil/a. Jsme tu pro tebe. '),
            const Spacer(),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(36.0)
              ),
              child: const Text(
                'Pokračovat',
              ),
            )
          ],
        ),
      ),
    );
  }
}

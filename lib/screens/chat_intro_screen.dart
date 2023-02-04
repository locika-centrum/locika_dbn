import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../widgets/paragraph_text.dart';
import '../widgets/info_page_scaffold.dart';

class ChatIntroScreen extends StatelessWidget {
  const ChatIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'Jsme tu pro tebe',
      route: '/',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ParagraphText('\nNecítíš se doma bezpečně?'),
          const ParagraphText('\nMáš strach o sebe nebo své blízké?'),
          const ParagraphText('\nČasto se u vás doma křičí, vyhrožuje?'),
          const ParagraphText(
              '\nUbližují si tvoji blízcí navzájem nebo přímo ubližují tobě?'),
          SvgPicture.asset('assets/images/kluk_pod_posteli.svg'),
          const ParagraphText(
            '\nNeboj se, nejsi v tom sám/a.',
            fontWeight: FontWeight.bold,
          ),
          const ParagraphText('\nNení to tvoje vina. Násilí doma není v pořádku.'),
          const ParagraphText(
              '\nJe důležité, abys o tom s někým mluvil/a. Jsme tu pro tebe.'),
        ],
      ),
      bottomButton: OutlinedButton(
        onPressed: () => context.go('/chat_menu'),
        style: OutlinedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48.0)),
        child: Text(
          'Pokračovat',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../widgets/scrolling_scaffold.dart';
import '../widgets/bullet_text.dart';

class AboutResetPasswordScreen extends StatelessWidget {
  const AboutResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScrollingScaffold(
      title: 'Zapomenuté heslo',
      closeRoute: '/reset_password',
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16.0,
            ),
            BulletText(
              text: 'Dostaneš mail na udanou adresu s odkazem na stránky https://locika.neziskovky.com/ kterým potvrdíš reset hesla.',
              color: BulletColor.blue,
            ),
            BulletText(
              text: 'Na základě potvrzení ti přijde druhý mail s novým heslem.',
              color: BulletColor.green,
            ),
            BulletText(
              text: 'To si zapamatuj - pokud si ho budeš chtít upravit na vlastní, tak ho můžeš změnit přes stránky https://locika.neziskovky.com/ po přihlášení na záložce "Můj účet".',
              color: BulletColor.yellow,
            ),
          ],
        ),
      ),
    );
  }
}

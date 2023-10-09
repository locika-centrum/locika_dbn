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
              text: 'Dostaneš e-mail na tvoji adresu s odkazem na stránky https://locika.neziskovky.com, kterým potvrdíš reset hesla.',
              color: BulletColor.blue,
            ),
            BulletText(
              text: 'Až potvrdíš reset hesla. přijde druhý e-mail s novým heslem.',
              color: BulletColor.green,
            ),
            BulletText(
              text: 'Nové heslo si zapamatuj. Pokud si ho budeš chtít upravit na vlastní, tak jej změníš přes stránky https://locika.neziskovky.com . Stačí se přihlásit a kliknout na záložku “Můj účet”.',
              color: BulletColor.yellow,
            ),
          ],
        ),
      ),
    );
  }
}

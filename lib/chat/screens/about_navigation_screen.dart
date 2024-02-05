import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';

import '../../widgets/scrolling_scaffold.dart';

Logger _log = Logger('call_botom_sheet.dart');

class AboutNavigationScreen extends StatelessWidget {
  String returnRoute;

  AboutNavigationScreen({Key? key, required this.returnRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      title: 'O navigaci',
      body: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Text(
            'Aplikace vyžaduje povolení přístupu k informaci o tvoji poloze. Poloha bude předána při komunikaci s policií.\n\nNa další obrazovce prosím potvrď možnost přístupu k polohový datům.'),
      ),
      actionButtonData: [
        ActionButtonData(
          actionString: 'Zpět',
          callback: () => _popScreen(context, returnRoute),
        )
      ],
    );
  }

  void _popScreen(BuildContext context, String returnRoute) async {
    LocationPermission permission = await GeolocatorPlatform.instance.requestPermission();

    if (permission == LocationPermission.denied) {
      _log.finest('Location permissions denied');
    }
    if (permission == LocationPermission.deniedForever) {
      _log.finest('Location permissions denied forever');
    }

    if (context.mounted) {
      context.go(returnRoute);
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../../utils/app_theme.dart';
import './redirect_button.dart';
import '../services/neziskovky_parser.dart';

Logger _log = Logger('call_botom_sheet.dart');

class CallBottomSheet {
  static void showDialog(BuildContext context, String returnRoute) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            16.0,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                child: GeolocatorWidget(
                  returnRoute: returnRoute,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RedirectButton(
                    label: 'Volat policii',
                    backgroundColor: AppTheme.primaryYellow,
                    buttonColor: AppTheme.primaryTextYellow,
                    callback: () => _makeCall(PolicePhoneNumber),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static _makeCall(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}

class GeolocatorWidget extends StatefulWidget {
  final String returnRoute;

  const GeolocatorWidget({Key? key, required this.returnRoute})
      : super(key: key);

  @override
  State<GeolocatorWidget> createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Position? position;
  List<Placemark> placemarks = [];

  @override
  void initState() {
    initStateAsync();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _log.finest(placemarks);
    String address =
        placemarks.isEmpty ? 'Neznámá adresa' : placemarks.first.street ?? '';
    address +=
        '\n${placemarks.isEmpty ? '' : placemarks.first.administrativeArea ?? ''}';
    address +=
        '\n${placemarks.isEmpty ? '' : placemarks.first.postalCode ?? ''}';

    return ListTile(
      leading: position == null
          ? const Icon(Icons.location_off)
          : const Icon(Icons.person_pin_circle),
      title: Text(address),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Text('šířka: ${position?.latitude ?? ''}'),
          Text('délka: ${position?.longitude ?? ''}'),
        ],
      ),
    );
  }

  Future<void> initStateAsync() async {
    position = await _getCurrentPositionNew();
    if (position != null) {
      placemarks = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
    }
    setState(() {});

    _log.finest(
        'Position retrieved: $position, Placemarks found: ${placemarks.length}');
  }

  Future<Position?> _getCurrentPositionNew() async {
    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    _log.finest('Position enabled: $serviceEnabled');

    if (serviceEnabled) {
      LocationPermission permission =
          await _geolocatorPlatform.checkPermission();
      _log.finest('LocationPermission: $permission');
      if (permission == LocationPermission.denied) {
        // show explanatory UI screen
        if (context.mounted) {
          context.go('/about_navigation', extra: widget.returnRoute);

          /*
          showOkAlertDialog(
              context: context,
              title: 'Přístup k poloze',
              message:
                  'Aplikace vyžaduje povolení přístupu k informaci o tvoji poloze. Poloha bude předána při komunikaci s policií.\n\nNa další obrazovce prosím potvrď možnost přístupu k polohový datům.',
              onPopInvoked: (bool didPop) async {
                permission = await _geolocatorPlatform.requestPermission();
                if (permission == LocationPermission.denied) {
                  _log.finest('Location permissions denied');
                  return;
                }
                if (permission == LocationPermission.deniedForever) {
                  _log.finest('Location permissions denied forever');
                  return;
                }

                position = await _geolocatorPlatform.getCurrentPosition();
                if (position != null) {
                  placemarks = await placemarkFromCoordinates(
                      position!.latitude, position!.longitude);
                }
                setState(() {});
                return;
              });
           */
        }
      } else {
        position = await _geolocatorPlatform.getCurrentPosition();
        if (position != null) {
          placemarks = await placemarkFromCoordinates(
              position!.latitude, position!.longitude);
        }
        setState(() {});

        return position;
      }
    }
    return null;
  }
}

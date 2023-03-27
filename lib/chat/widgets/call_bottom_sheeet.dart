import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logging/logging.dart';

import '../../utils/app_theme.dart';
import './redirect_button.dart';

Logger _log = Logger('call_botom_sheet.dart');

class CallBottomSheet {
  // TODO put the correct phone number
  static const number = '';

  static void showDialog(BuildContext context) {
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
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0,),
                child: GeolocatorWidget(),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RedirectButton(
                    label: 'Volat policii',
                    backgroundColor: AppTheme.primaryYellow,
                    buttonColor: AppTheme.primaryTextYellow,
                    callback: () => _makeCall(number),
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
  const GeolocatorWidget({Key? key}) : super(key: key);

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

    if (serviceEnabled) {
      LocationPermission permission =
          await _geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _geolocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          _log.finest('Location permissions denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _log.finest('Location permissions denied forever');
        return null;
      }

      // Permission is granted - check the location
      return await _geolocatorPlatform.getCurrentPosition();
    }
    _log.finest('Location service is not enabled');
    return null;
  }
}

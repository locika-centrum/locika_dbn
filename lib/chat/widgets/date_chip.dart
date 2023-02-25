import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChip extends StatelessWidget {
  final DateTime date;
  final Color color;
  final bool includeTime;

  static final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormatter = DateFormat('yyyy-MM-dd hh:mm');

  const DateChip({
    Key? key,
    required this.date,
    this.color = const Color(0x558AD3D5),
    this.includeTime = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 7,
        bottom: 7,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            dateChipText(date),
          ),
        ),
      ),
    );
  }

  String dateChipText(DateTime date) {
    String result = '';
    final now = DateTime.now();

    if (_dateFormatter.format(now) == _dateFormatter.format(date)) {
      result = Platform.localeName == 'cs_CZ' ? 'Dnes' : 'Today';
    } else if (_dateFormatter
            .format(DateTime(now.year, now.month, now.day - 1)) ==
        _dateFormatter.format(date)) {
      result = Platform.localeName == 'cs_CZ' ? 'Včera' : 'Yesterday';
    } else {
      result = DateFormat.yMMMMd(Platform.localeName).format(date);
    }

    if (includeTime) {
      result += ' ${DateFormat.Hm().format(date)}';
    }

    return result;
  }
}

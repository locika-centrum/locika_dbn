import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'settings_data.g.dart';

@HiveType(typeId: 0)
class SettingsData extends ChangeNotifier with HiveObjectMixin {
  static const String hiveBoxName = 'settings-box';
  static const String settingsKey = 'settings';

  final gameSizes = ['malá', 'střední', 'velká', 'největší'];
  bool _isReady = false;
  bool get isReady => _isReady;
  set isReady(bool ready) {
    _isReady = ready;
    notifyListeners();
  }

  @HiveField(0, defaultValue: 0)
  int _gameSize;
  int get gameSize => _gameSize;
  set gameSize(int size) {
    _gameSize = size;
    notifyListeners();

    save();
  }

  @HiveField(1, defaultValue: false)
  bool _slidingPictures;
  bool get slidingPictures => _slidingPictures;
  set slidingPictures(bool value) {
    _slidingPictures = value;
    notifyListeners();

    save();
  }

  @HiveField(2, defaultValue: true)
  bool _tictactoeStartsHuman;
  bool get tictactoeStartsHuman => _tictactoeStartsHuman;
  set tictactoeStartsHuman(bool value) {
    _tictactoeStartsHuman = value;
    notifyListeners();

    save();
  }

  @HiveField(3, defaultValue: true)
  bool _reversiStartsHuman;
  bool get reversiStartsHuman => _reversiStartsHuman;
  set reversiStartsHuman(bool value) {
    _reversiStartsHuman = value;
    notifyListeners();

    save();
  }

  SettingsData(
      {int gameSize = 0,
      bool slidingPictures = false,
      bool tictactoeStartsHuman = true,
      bool reversiStartsHuman = true})
      : _gameSize = gameSize,
        _slidingPictures = slidingPictures,
        _tictactoeStartsHuman = tictactoeStartsHuman,
        _reversiStartsHuman = reversiStartsHuman;

  @override
  String toString() {
    return '{gameSize: $gameSize, slidingPictures: $slidingPictures, tictactoeStartsHuman: $tictactoeStartsHuman, reversiStartsHuman: $reversiStartsHuman,}';
  }
}

class SettingsPickerData {
  final String title;
  final List<String> options;
  final int selectedOption;
  final Function onChange;

  SettingsPickerData({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onChange,
  });
}

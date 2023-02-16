import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPickerScreen extends StatelessWidget {
  final String title;
  final List<String> options;
  final int selectedOption;
  final Function onChange;

  const SettingsPickerScreen({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Nastavení',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(title),
            tiles: options.asMap().entries.map<SettingsTile>((item) {
              return SettingsTile(
                title: Text(item.value),
                onPressed: (_) {
                  onChange(item.key);
                  Navigator.of(context).pop();
                },
                trailing: Icon(item.key == selectedOption ? Icons.check : null),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

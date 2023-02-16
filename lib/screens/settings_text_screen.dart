import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsTextScreen extends StatefulWidget {
  final String title;
  final String text;
  final Function onChange;

  const SettingsTextScreen({
    required this.title,
    required this.text,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsTextScreen> createState() => _SettingsTextScreenState();
}

class _SettingsTextScreenState extends State<SettingsTextScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.text ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Nastavení',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(widget.title),
            tiles: [
              SettingsTile(
                title: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: widget.title,
                    border: InputBorder.none,
                  ),
                  onEditingComplete: () {
                    widget.onChange(_textController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

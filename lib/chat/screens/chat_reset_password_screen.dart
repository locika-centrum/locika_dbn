import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locika_dbn_test/chat/widgets/menu_action_panel.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../settings/model/settings_data.dart';
import '../../widgets/app_bar_chat.dart';
import '../models/chat_response.dart';
import '../services/neziskovky_parser.dart';

Logger _log = Logger('chat_reset_password_screen.dart');

class ChatResetPassword extends StatefulWidget {
  final String? nickName;

  const ChatResetPassword({this.nickName, Key? key}) : super(key: key);

  @override
  State<ChatResetPassword> createState() => _ChatResetPasswordState();
}

class _ChatResetPasswordState extends State<ChatResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nickNameController;
  final TextEditingController _emailController = TextEditingController();
  String? errorNick;
  String? errorEmail;
  bool _isValidForm = true;

  @override
  void initState() {
    _nickNameController = TextEditingController(text: widget.nickName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(
        route: '/',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Zapomenuté heslo',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  TextField(
                    controller: _nickNameController,
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: 'Přezdívka',
                      labelText: 'Přezdívka',
                      contentPadding:
                          EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      contentPadding:
                          EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          MenuActionPanel(
            title: 'Neznám heslo',
            text: 'Když zapomeneš svoje heslo - nevadí, je možné požádat o jeho nové nastavení',
            hintText: 'Jak to proběhne',
            hintRoute: '/about_reset_password',
            backgroundColor: const Color(0xff0567ad).withOpacity(0.15),
          ),
          const Spacer(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () async => requestPasswordReset(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xff0567ad),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48.0),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Změna hesla',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> requestPasswordReset() async {
    setState(() {
      errorNick = null;
      errorEmail = null;
    });

    if (_formKey.currentState!.validate()) {
      context.read<SettingsData>().nickName = _nickNameController.text;

      _log.finest('RESET PASSWORD');
      ChatResponse result = await resetPassword(
        nickName: _nickNameController.text,
        email: _emailController.text,
      );
    }
  }
}

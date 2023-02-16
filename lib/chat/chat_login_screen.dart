import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../settings/model/settings_data.dart';
import '../widgets/app_bar_chat.dart';
import 'models/chat_response.dart';
import 'models/session_data.dart';
import 'services/neziskovky_parser.dart';

Logger _log = Logger('chat_login_screen.dart');

class ChatLoginScreen extends StatefulWidget {
  final String? nickName;

  const ChatLoginScreen({this.nickName, Key? key}) : super(key: key);

  @override
  State<ChatLoginScreen> createState() => _ChatLoginScreenState();
}

class _ChatLoginScreenState extends State<ChatLoginScreen> {
  late TextEditingController _nickNameController;
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
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
        showAboutLink: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        children: [
          SizedBox(height: 48.0),
          SafeArea(
            child: SvgPicture.asset('assets/images/locika_logo.svg'),
          ),
          SizedBox(height: 48.0),
          TextField(
            controller: _nickNameController,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Přezdívka',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _passwordController,
            autofocus: false,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              hintText: 'Heslo',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              errorText: _isValidForm ? null : 'Chybné heslo nebo přezdívka',
              suffixIcon: IconButton(
                icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                context.read<SettingsData>().nickName =
                    _nickNameController.text;
                ChatResponse result = await authenticate(
                  username: _nickNameController.text,
                  password: _passwordController.text,
                );

                if (context.mounted) {
                  switch (result.statusCode) {
                    case 200:
                      _isValidForm = true;
                      context.read<SessionData>().cookie = result.cookie;
                      _log.finest('Storing cookie: ${result.cookie}');

                      context.go('/chat');
                      break;

                    case 401:
                      setState(() { _isValidForm = false; });
                      break;

                    default:
                      context.go('/work_in_progress');
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48.0)),
              child: Text(
                'Přihlásit se',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/register');
            },
            child: Text('Registruj se'),
          ),
        ],
      ),
    );
  }
}

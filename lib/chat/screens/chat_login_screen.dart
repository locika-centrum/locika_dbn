import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../settings/model/settings_data.dart';
import '../../widgets/app_bar_chat.dart';
import '../models/chat_response.dart';
import '../models/session_data.dart';
import '../services/neziskovky_parser.dart';

Logger _log = Logger('chat_login_screen.dart');

class ChatLoginScreen extends StatefulWidget {
  final String? nickName;

  const ChatLoginScreen({
    this.nickName,
    Key? key,
  }) : super(key: key);

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
      ),
      resizeToAvoidBottomInset : false,
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Přihlaš se',
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
                contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              autofocus: false,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: 'Heslo',
                labelText: 'Heslo',
                contentPadding:
                    const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                errorText: _isValidForm ? null : 'Chybné heslo nebo přezdívka',
                suffixIcon: IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () async => login(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xff0567ad),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48.0),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Přihlásit se',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () => context.go('/sign_up'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48.0),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Ještě nemám účet',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: const Color(0xff0567ad),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () => context.go('/reset_password'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(48.0),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Zapomenuté heslo',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: const Color(0xff0567ad),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),),
    );
  }

  Future<void> login() async {
    context.read<SettingsData>().nickName = _nickNameController.text;
    ChatResponse result = await authenticate(
      username: _nickNameController.text,
      password: _passwordController.text,
    );

    if (context.mounted) {
      switch (result.statusCode) {
        case 200:
          _isValidForm = true;
          context
              .read<SessionData>()
              .cookie = result.cookie;
          _log.finest('Storing cookie: ${result.cookie}');

          context.go(
            '/chat',
            extra: result.cookie,
          );
          break;

        case 401:
          setState(() {
            _isValidForm = false;
          });
          break;

        default:
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Chyba při loginu: ${result.statusCode}: ${result.message}: ${result.data.toString()}'),
              ),
          );
          context.go('/work_in_progress');
      }
    }
  }
}

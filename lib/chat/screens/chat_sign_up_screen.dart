import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../settings/model/settings_data.dart';
import '../../widgets/app_bar_chat.dart';
import '../models/chat_response.dart';
import '../models/session_data.dart';
import '../services/neziskovky_parser.dart';

Logger _log = Logger('chat_sign_up_screen.dart');

class ChatSignUpScreen extends StatefulWidget {
  const ChatSignUpScreen({Key? key}) : super(key: key);

  @override
  State<ChatSignUpScreen> createState() => _ChatSignUpScreenState();
}

class _ChatSignUpScreenState extends State<ChatSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nickNameController = TextEditingController();
  String? errorNick;
  final TextEditingController _passwordController = TextEditingController();
  String? errorPassword;

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(
        route: '/',
      ),
      body: Padding(
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
                  'Zaregistruj se',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              TextFormField(
                controller: _nickNameController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Přezdívka',
                  labelText: 'Přezdívka',
                  contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                  errorText: errorNick,
                ),
                validator: (value) {
                  if ((value?.length ?? 0) == 0) {
                    return 'Přezdívka je povinná';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                autofocus: false,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: 'Heslo',
                  labelText: 'Heslo',
                  contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                  errorText: errorPassword,
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
                validator: (value) {
                  if ((value?.length ?? 0) < 6) {
                    return 'Heslo musí obsahovat 6 znaků';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () async => signUp(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xff0567ad),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48.0),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Registrovat se',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () => context.go('/login'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(48.0),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Už mám účet',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: const Color(0xff0567ad),
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    setState(() {
      errorNick = null;
      errorPassword = null;
    });

    if (_formKey.currentState!.validate()) {
      context.read<SettingsData>().nickName = _nickNameController.text;

      ChatResponse result = await register(
        username: _nickNameController.text,
        password: _passwordController.text,
      );

      _log.finest('Status ${result.statusCode} - ${result.message}');
      switch (result.statusCode) {
        case 200:
          if (context.mounted) {
            context.read<SessionData>().cookie = result.cookie;
            _log.finest('Storing cookie: ${result.cookie} for ${_nickNameController.text} / ${context.read<SettingsData>().nickName}');

            context.go(
              '/about_chat',
              extra: result.cookie,
            );
          }
          break;
        case 401:
          if (result.message!.contains('existuje')) {
            _log.finest('Existující účet');
            setState(() {
              errorNick = result.message;
              errorPassword = null;
            });
          } else {
            _log.finest('Chyba v hesle');
            setState(() {
              errorNick = null;
              errorPassword = result.message;
            });
          }
          break;
        default:
          setState(() {
            errorPassword = 'Chyba komunikace - zkus to později';
          });
      }
    }
  }
}

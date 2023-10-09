import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:logging/logging.dart';

import 'package:locika_dbn_test/chat/services/neziskovky_parser.dart';
import '../../widgets/scrolling_scaffold.dart';

Logger _log = Logger('email_screen.dart');

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollingScaffold(
      closeRoute: '/chat',
      body: Column(
        children: [
          FutureBuilder(
            future: rootBundle.loadString('assets/texts/email.md'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Markdown(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        data: snapshot.data!,
                        styleSheet: MarkdownStyleSheet(
                          h1: Theme.of(context).textTheme.displayLarge,
                          p: Theme.of(context).textTheme.displaySmall,
                          h6Align: WrapAlignment.center,
                          tableColumnWidth: const IntrinsicColumnWidth(),
                          tableBody: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Tvoje e-mailová adresa',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _messageController,
                          minLines: 6,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Tvoje zpráva',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          /*
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () => sendMail(),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xff0567ad),
                minimumSize: const Size.fromHeight(48.0),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Odeslat přes klienta',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          SafeArea(
            child: Container(),
          ),
          */
        ],
      ),
      actionButtonData: [
        ActionButtonData(
          actionString: 'Odeslat e-mail',
          callback: () => sendMail(
            _emailController.text,
            _messageController.text,
          ),
          actionBackgroundColor: const Color(0xff0567ad),
        )
      ],
    );
  }

  void sendMail(String email, String message) {
    _log.finest('sending mail ... ($email)');

    sendMailThroughForm(
      email: email,
      messagereal: message,
    );

    /*
    sendMailThroughClient(
      email: email,
      messagereal: message,
    );
    */

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ozveme se ti na $email.'),
      ),
    );

    context.go('/');
  }
}

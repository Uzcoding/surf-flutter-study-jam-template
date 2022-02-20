import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_practice_chat_flutter/firebase_options.dart';
import 'package:surf_practice_chat_flutter/screens/chat.dart';
import 'package:surf_practice_chat_flutter/screens/chat_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform(
      androidKey: 'AIzaSyCXU5f25S_SUeVv7cAzoeF373kHk4Hv2dE',
      iosKey: 'AIzaSyAjvNoe31ZMSakjKFOkhbrZBsj3RyW6plo',
      webKey: 'AIzaSyD40PR_fizjSYtCZEtXgwq_5LdJu2w2zIs',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}

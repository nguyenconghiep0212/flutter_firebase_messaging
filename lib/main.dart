import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'notification_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Handler background message
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationApi.showNotification(
      title: 'Local Notification', body: 'Message ID:${message.messageId}');
  log('CHECKPOINT 1: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Background message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Catch firebase initial message
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleMessage);

    FirebaseMessaging.instance.getToken().then((token) {
      log("Push Messaging token: $token");
    });
  }

  void _handleMessage(RemoteMessage message) {
    log("CHECKPOINT 2: ${message.data}");
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context, '/chat',
        // arguments: ChatArguments(message),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Hi"),
        ),
      ),
    );
  }
}

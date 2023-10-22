import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recsseem_mobile/HeaderandFooter/footer.dart';
import 'package:recsseem_mobile/shared/constants.dart';
import 'login/login_page.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId,
      )
    );
  }
  else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      scrollBehavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.trackpad,
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasData) {
            return const Footer(pageNumber: 0);
          }

          return const LoginPage();
        },
      ),
    );
  }
}


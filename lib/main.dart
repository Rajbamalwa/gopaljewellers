import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gopaljewellers/backend/supabase/Supabase.dart';
import 'package:gopaljewellers/provider/admin_provider.dart';
import 'package:gopaljewellers/provider/provider.dart';
import 'package:gopaljewellers/services/internet.dart';
import 'package:gopaljewellers/views/Home/home_screen.dart';
import 'package:gopaljewellers/views/login/login_screen.dart';
import 'package:provider/provider.dart';

import 'backend/authentication/auth_util.dart';
import 'backend/authentication/firebase_user_provider.dart';
import 'constants/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDUFXfhqJ2NjWfnMLvZ5JsoGmDHS_7-Jwo',
      appId: '1:1083530900540:ios:f341690805e1123bd5bf39',
      messagingSenderId: '1083530900540',
      projectId: 'gopal-jewellers-28d82',
    ),
  );
  await SupaFlow.initialize();
  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Preventing Landscape Mode in the application
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final authFirebase = FirebaseAuth.instance.currentUser;

  late Stream<NiogenFirebaseUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();
    userStream = niogenirebaseUserStream()..listen((user) {});
  }

  @override
  void dispose() {
    authUserSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CheckInternet()),
        ChangeNotifierProvider(create: (_) => drawerProvider()),
        ChangeNotifierProvider(create: (_) => AdminBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gopal Jewellers',
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: AppBarTheme(
            color: primaryColor,
            iconTheme: IconThemeData(
              color: primaryColor22,
            ),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 2), () {
      checkLogin();
    });
  }

  checkLogin() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => PhoneView()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Image.asset(
                "assets/images/logo.png",
                // width: width * 0.5,
                fit: BoxFit.cover,
              ),
            ).animate().scaleXY(duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}

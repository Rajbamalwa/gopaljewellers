import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/device_info.dart';
import '../firebase/analytits.dart';
import '../schema/users_record.dart';
import 'firebase_user_provider.dart';

Future signOut() async {
  logFirebaseEvent("SIGN_OUT");
  DocumentSnapshot<Object?> data =
      await UsersRecord.collection.doc(currentUserUid).get();
  List deviceIds = data.get("device_tokens").toSet().toList();

  DeviceInformation deviceInformation = DeviceInformation();

  deviceInformation.getDeviceInfo().then((id) async {
    deviceIds.remove(id);
    await UsersRecord.collection
        .doc(currentUserUid)
        .update({"device_tokens": deviceIds});

    await FirebaseMessaging.instance.unsubscribeFromTopic(id);
  });

  return FirebaseAuth.instance.signOut();
}

Future deleteUser(BuildContext context) async {
  try {
    if (currentUser?.user == null) {
      print('Error: delete user attempted with no logged in user!');
      return;
    }
    await currentUser?.user?.delete();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Too long since most recent sign in. Sign in again before deleting your account.')),
      );
    }
  }
}

Future<User?> signInOrCreateAccount(
  BuildContext context,
  Future<UserCredential?> Function() signInFunc,
  String authProvider,
) async {
  try {
    final userCredential = await signInFunc();
    logFirebaseAuthEvent(userCredential?.user, authProvider);

    if (userCredential?.user != null) {
      await maybeCreateUser(userCredential!.user!);
    }

    return userCredential?.user;
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message!}')),
    );
    return null;
  }
}

Future maybeCreateUser(User user) async {
  final userRecord = UsersRecord.collection.doc(user.uid);
  final userExists = await userRecord.get().then((u) => u.exists);
  if (userExists) {
    return;
    // }
    //
    // DeviceInformation deviceInformation = DeviceInformation();
    //
    // deviceInformation.getDeviceInfo().then((value) async {
    //   final userData = createUsersRecordData(
    //     email: user.email,
    //     first_name: user.displayName,
    //     photoUrl: user.photoURL,
    //     uid: user.uid,
    //     phoneNumber: user.phoneNumber,
    //     createdTime: getCurrentTimestamp,
    //     bidsUnseen: 0,
    //     deviceTokens: BuiltList<String>([value]),
    //   );
    //
    //   await userRecord.set(userData);
    //   await userRecord.set(
    //       {
    //         "address": [],
    //         "documents": {
    //           "remarks": "",
    //           "verified": false,
    //         },
    //         "fcmTokens": {}
    //       },
    //       SetOptions(
    //         merge: true,
    //       ));
    //   currentUserDocument =
    //       serializers.deserializeWith(UsersRecord.serializer, userData);
    // });
  }
}

Future resetPassword(
    {required String email, required BuildContext context}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message!}')),
    );
    return null;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Password reset email sent')),
  );
}

Future sendEmailVerification() async =>
    currentUser?.user?.sendEmailVerification();

String get currentUserEmail =>
    currentUserDocument?.email ?? currentUser?.user?.email ?? '';

String get currentUserUid => currentUser?.user?.uid ?? '';

String get currentUserDisplayName =>
    currentUserDocument?.displayName ?? currentUser?.user?.displayName ?? '';

String get currentUserPhoto =>
    currentUserDocument?.photoUrl ??
    currentUser?.user?.photoURL ??
    'https://cdn-icons-png.flaticon.com/512/149/149071.png';

String get currentPhoneNumber =>
    currentUserDocument?.phoneNumber ?? currentUser?.user?.phoneNumber ?? '';
String get fcmToken => currentUserDocument?.fcm ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified {
  // Reloads the user when checking in order to get the most up to date
  // email verified status.
  if (currentUser?.user != null && !currentUser!.user!.emailVerified) {
    currentUser!.user!
        .reload()
        .then((_) => currentUser!.user = FirebaseAuth.instance.currentUser);
  }
  return currentUser?.user?.emailVerified ?? false;
}

/// Create a Stream that listens to the current user's JWT Token, since Firebase
/// generates a new token every hour.
String? _currentJwtToken;
final jwtTokenStream = FirebaseAuth.instance
    .idTokenChanges()
    .map((user) async => _currentJwtToken = await user?.getIdToken())
    .asBroadcastStream();

// // Set when using phone verification (after phone number is provided).
// String? _phoneAuthVerificationCode;
// // Set when using phone sign in in web mode (ignored otherwise).
// ConfirmationResult? _webPhoneAuthConfirmationResult;
//
// Future beginPhoneAuth({
//   required BuildContext context,
//   required String phoneNumber,
//   required VoidCallback onCodeSent,
// }) async {
//   if (kIsWeb) {
//     _webPhoneAuthConfirmationResult =
//         await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
//     onCodeSent();
//     return;
//   }
//   final completer = Completer<bool>();
//   // If you'd like auto-verification, without the user having to enter the SMS
//   // code manually. Follow these instructions:
//   // * For Android: https://firebase.google.com/docs/auth/android/phone-auth?authuser=0#enable-app-verification (SafetyNet set up)
//   // * For iOS: https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0#start-receiving-silent-notifications
//   // * Finally modify verificationCompleted below as instructed.
//   await FirebaseAuth.instance.verifyPhoneNumber(
//     phoneNumber: phoneNumber,
//     timeout: Duration(seconds: 5),
//     verificationCompleted: (phoneAuthCredential) async {
//       await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
//
//       // If you've implemented auto-verification, navigate to home page or
//       // onboarding page here manually. Uncomment the lines below and replace
//       // DestinationPage() with the desired widget.
//       // await Navigator.push(
//       //   context,
//       //   MaterialPageRoute(builder: (_) => DestinationPage()),
//       // );
//     },
//     verificationFailed: (e) {
//       completer.complete(false);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: ${e.message!}'),
//       ));
//     },
//     codeSent: (verificationId, _) {
//       _phoneAuthVerificationCode = verificationId;
//       completer.complete(true);
//       onCodeSent();
//     },
//     codeAutoRetrievalTimeout: (_) {},
//   );
//
//   return completer.future;
// }
//
// Future verifySmsCode({
//   required BuildContext context,
//   required String smsCode,
// }) async {
//   if (kIsWeb) {
//     return signInOrCreateAccount(
//       context,
//       () => _webPhoneAuthConfirmationResult!.confirm(smsCode),
//       'PHONE',
//     );
//   } else {
//     final authCredential = PhoneAuthProvider.credential(
//         verificationId: _phoneAuthVerificationCode!, smsCode: smsCode);
//     return signInOrCreateAccount(
//       context,
//       () => FirebaseAuth.instance.signInWithCredential(authCredential),
//       'PHONE',
//     );
//   }
// }

DocumentReference? get currentUserReference => currentUser?.user != null
    ? UsersRecord.collection.doc(currentUser!.user!.uid)
    : null;

UsersRecord? currentUserDocument;
final authenticatedUserStream = FirebaseAuth.instance
    .authStateChanges()
    .map<String>((user) => user?.uid ?? '')
    .switchMap(
      (uid) => uid.isEmpty
          ? Stream.value(null)
          : UsersRecord.getDocument(UsersRecord.collection.doc(uid))
              .handleError((_) {}),
    )
    .map((user) => currentUserDocument = user)
    .asBroadcastStream();

class AuthUserStreamWidget extends StatefulWidget {
  const AuthUserStreamWidget({Key? key, required this.builder})
      : super(key: key);

  final WidgetBuilder builder;

  @override
  State<AuthUserStreamWidget> createState() => _AuthUserStreamWidgetState();
}

class _AuthUserStreamWidgetState extends State<AuthUserStreamWidget> {
  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authenticatedUserStream,
        builder: (context, _) => widget.builder(context),
      );
}

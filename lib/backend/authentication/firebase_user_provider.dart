import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class NiogenFirebaseUser {
  NiogenFirebaseUser(this.user);

  User? user;

  bool get loggedIn => user != null;
}

NiogenFirebaseUser? currentUser;

bool get loggedIn => currentUser?.loggedIn ?? false;

Stream<NiogenFirebaseUser> niogenirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<NiogenFirebaseUser>(
      (user) {
        currentUser = NiogenFirebaseUser(user);
        if (!kIsWeb) {
          FirebaseCrashlytics.instance.setUserIdentifier(user?.uid ?? '');
        }
        return currentUser!;
      },
    );

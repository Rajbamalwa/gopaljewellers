import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminBloc extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? _adminPass;
  String _userType = 'Admin';
  bool _isSignedIn = false;
  bool _isguestAdmin = false;
  bool _testing = false;

  AdminBloc() {
    checkSignIn();
    getAdminPass();
    ResetGuestAdmin();
  }

  String? get adminPass => _adminPass;
  String get userType => _userType;
  bool get isSignedIn => _isSignedIn;
  bool get testing => _testing;
  bool get isguestAdmin => _isguestAdmin;

  void getAdminPass() {
    FirebaseFirestore.instance
        .collection('admin')
        .doc('user type')
        .get()
        .then((DocumentSnapshot snap) {
      String? aPass = snap['admin password'];
      _adminPass = aPass;
      notifyListeners();
    });
  }

  Future saveNewAdminPassword(String newPassword) async {
    await firestore.collection('admin').doc('user type').update(
        {'admin password': newPassword}).then((value) => getAdminPass());
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed in', true);
    _isSignedIn = true;
    _userType = 'admin';
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed in') ?? false;
    notifyListeners();
  }

  Future setSignInForTesting() async {
    _testing = true;
    _userType = 'tester';
    notifyListeners();
  }

  Future setSignInForGuestAdmin() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('Guest Admin', true);
    _isguestAdmin = true;
    notifyListeners();
  }

  Future ResetGuestAdmin() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isguestAdmin = sp.getBool('Guest Admin') ?? false;
    notifyListeners();
  }
}

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

final authFirebase = FirebaseAuth.instance;

class Helpers {
  static String generateTransactionId() {
    final Random random = Random();
    const String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    String transactionId = '';
    for (int i = 0; i < 10; i++) {
      transactionId += characters[random.nextInt(characters.length)];
    }
    return transactionId;
  }

  static String getOrderId() {
    var result = '';
    var characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < 8; i++) {
      result += characters[(Random().nextDouble() * charactersLength).floor()];
    }

    return result;
  }

  static String generateOrganisationId() {
    var result = '';
    var characters =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    var charactersLength = characters.length;
    for (var i = 0; i < 20; i++) {
      result += characters[(Random().nextDouble() * charactersLength).floor()];
    }

    return result;
  }

  static String getBookingId() {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < 10; i++) {
      result += characters[(Random().nextDouble() * charactersLength).floor()];
    }

    return result;
  }

  static Future<void> openUrl(url) async {
    await launch(url);
  }

  static bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  // Generate a random string of characters
  String randomChars = String.fromCharCodes(
      List.generate(6, (index) => (Random().nextInt(26) + 65)));

  // List of random messages
  final List<String> randomMessages = [
    "🛒 Order Placed!",
    "📦 Order Confirmed!",
    "🎉 Order Placed Successfully!",
    "👍 Order Confirmed!",
    "📥 Your Order is Placed!",
    "✅ Order Successfully Placed!",
    "🛍️ Order Successfully Processed!",
    "💳 Your Order is Confirmed!",
    "🔖 Order Confirmation!",
    "📮 Your Order is on its Way!",
    "👌 Order Received!",
    "🚚 Order is in Process!",
  ];

  String randomTitle() {
    // Select a random message
    final Random random = Random();
    final int index = random.nextInt(randomMessages.length);
    final String randomMessage = randomMessages[index];
    return randomMessage;
  }
}

String referralId = authFirebase.currentUser!.displayName!
        .substring(0, min(4, authFirebase.currentUser!.displayName!.length))
        .toUpperCase() +
    Helpers().randomChars;

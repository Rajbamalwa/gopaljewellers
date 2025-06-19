import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gopaljewellers/constants/list.dart';
import 'package:url_launcher/url_launcher.dart';

final authFirebase = FirebaseAuth.instance;

class Helpers {
  static String genearateProductTypeId() {
    final Random random = Random();
    const String characters = "0123456789";
    String transactionId = '';
    String id = '';
    for (int i = 0; i < 5; i++) {
      id += characters[random.nextInt(characters.length)];
    }
    transactionId = "GJ${id.toString()}";
    return transactionId;
  }

  static String genearateProductId() {
    final Random random = Random();
    const String characters = "0123456789";
    String transactionId = '';
    String id = '';
    for (int i = 0; i < 5; i++) {
      id += characters[random.nextInt(characters.length)];
    }
    transactionId = "GJ${id.toString()}";
    return transactionId;
  }

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

  String randomTitle() {
    // Select a random message
    final Random random = Random();
    final int index = random.nextInt(randomMessages.length);
    final String randomMessage = randomMessages[index];
    return randomMessage;
  }

  // Function to get a random catalog message
  String getRandomCatalogMessage() {
    Random random = Random();
    int randomIndex = random.nextInt(catalogMessages.length);
    return catalogMessages[randomIndex];
  }
}

String referralId = authFirebase.currentUser!.displayName!
        .substring(0, min(4, authFirebase.currentUser!.displayName!.length))
        .toUpperCase() +
    Helpers().randomChars;

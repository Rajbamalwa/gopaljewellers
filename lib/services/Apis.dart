import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> sendNotification(token, title, body, type, id) async {
    var data = {
      'to': token.toString(),
      'notification': {
        'title': title.toString(),
        'body': body.toString(),
        // "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {'type': type.toString(), 'id': id.toString()}
    };

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAA_Ed5dDw:APA91bHXfwGPj_17uDVRaHqggVZi1zZED9kibr3axpP8eJmuIS8e6D6ddL1fAAnN608-lhPmvuWbDM6IuYEffH2AHoBxpybQYLjuNKMoaCq9i2767aWfwXmsQO-f_pV5qSDCCc-7_Dqa'
        },
      );
      log("body _ ${response.body.toString()}");
    } catch (error) {
      log("ERROR _ $error");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  var auth = FirebaseAuth.instance.currentUser;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

// // import 'package:timezone/timezone.dart' as tz;
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import '../backend/authentication/auth_util.dart';
// // import '../backend/schema/users_record.dart';
// // import '../backend/supabase/Supabase.dart';
// // import 'device_info.dart';
// //
// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //     FlutterLocalNotificationsPlugin();
// //
// // class NotificationService {
// //   static final NotificationService _notificationService =
// //       NotificationService._internal();
// //
// //   factory NotificationService() {
// //     return _notificationService;
// //   }
// //
// //   NotificationService._internal();
// //
// //   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //
// //   void initLocalNotifications(RemoteMessage message) async {
// //     var androidInitializationSettings =
// //         const AndroidInitializationSettings('@mipmap/ic_launcher');
// //     var iosInitializationSettings = const DarwinInitializationSettings();
// //
// //     var initializationSetting = InitializationSettings(
// //         android: androidInitializationSettings, iOS: iosInitializationSettings);
// //
// //     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
// //         onDidReceiveNotificationResponse: (payload) {
// //       // handle interaction when app is active for android
// //       handleMessage(message);
// //     });
// //   }
// //
// //   void firebaseInit(BuildContext context) {
// //     FirebaseMessaging.onMessage.listen((message) {
// //       if (Platform.isAndroid) {
// //         initLocalNotifications(message);
// //         showNot(message);
// //       }
// //       if (Platform.isIOS) {
// //         initLocalNotifications(message);
// //         showNot(message);
// //       }
// //     });
// //   }
// //
// //   void handleMessage(RemoteMessage message) {}
// //
// //   Future<void> setupInteractMessage(BuildContext context) async {
// //     await FirebaseMessaging.instance
// //         .setForegroundNotificationPresentationOptions(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //     );
// //
// //     // when app is terminated
// //     RemoteMessage? initialMessage =
// //         await FirebaseMessaging.instance.getInitialMessage();
// //
// //     if (initialMessage != null) {
// //       handleMessage(initialMessage);
// //     }
// //
// //     //when app ins background
// //     FirebaseMessaging.onMessageOpenedApp.listen((event) {
// //       handleMessage(event);
// //     });
// //   }
// //
// //   Future<void> showNot(RemoteMessage message) async {
// //     AndroidNotificationChannel channel = AndroidNotificationChannel(
// //       message.notification!.android!.channelId.toString(),
// //       message.notification!.android!.channelId.toString(),
// //       importance: Importance.max,
// //       showBadge: true,
// //     );
// //
// //     AndroidNotificationDetails androidNotificationDetails =
// //         AndroidNotificationDetails(
// //       channel.id.toString(),
// //       channel.name.toString(),
// //       channelDescription: 'your channel description',
// //       importance: Importance.high,
// //       priority: Priority.high,
// //       ticker: 'ticker',
// //     );
// //
// //     const DarwinNotificationDetails darwinNotificationDetails =
// //         DarwinNotificationDetails(
// //             presentAlert: true, presentBadge: true, presentSound: true);
// //
// //     NotificationDetails notificationDetails = NotificationDetails(
// //       android: androidNotificationDetails,
// //       iOS: darwinNotificationDetails,
// //     );
// //
// //     Future.delayed(Duration.zero, () {
// //       _flutterLocalNotificationsPlugin.show(
// //         message.notification!.hashCode,
// //         message.notification!.title.toString(),
// //         message.notification!.body.toString(),
// //         notificationDetails,
// //       );
// //     });
// //   }
// //
// //   notificationDetails() {
// //     return const NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           'channelId',
// //           'channelName',
// //           importance: Importance.max,
// //           playSound: true,
// //         ),
// //         iOS: DarwinNotificationDetails());
// //   }
// //
// //   Future sendNotification(
// //       {int id = 0, String? title, String? body, String? payLoad}) async {
// //     return _flutterLocalNotificationsPlugin.show(
// //         id, title, body, await notificationDetails());
// //   }
// //
// //   Future scheduleNotification(
// //       {int id = 0,
// //       String? title,
// //       String? body,
// //       required DateTime scheduledNotificationDateTime}) async {
// //     return _flutterLocalNotificationsPlugin.zonedSchedule(
// //         id,
// //         title,
// //         body,
// //         tz.TZDateTime.from(
// //           scheduledNotificationDateTime,
// //           tz.local,
// //         ),
// //         await notificationDetails(),
// //         androidAllowWhileIdle: true,
// //         uiLocalNotificationDateInterpretation:
// //             UILocalNotificationDateInterpretation.absoluteTime);
// //   }
// //
// //   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
// //
// //   DeviceInformation deviceInformation = DeviceInformation();
// //
// //   Future<void> saveFcmToFireBase(String fcmToken) async {
// //     DocumentSnapshot data =
// //         await UsersRecord.collection.doc(currentUserUid).get();
// //     await SupaFlow.client
// //         .from('users')
// //         .select()
// //         .eq('user_id', currentUserUid)
// //         .execute();
// //     Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;
// //     dynamic deviceIds = dataMap["fcmTokens"];
// //     firebaseMessaging.subscribeToTopic("ALL");
// //     deviceInformation.getDeviceInfo().then((value) async {
// //       deviceIds = fcmToken.toString();
// //
// //       // deviceIds[value.toString()] = fcmToken.toString();
// //       await SupaFlow.client.from('users').update({
// //         'firebase_token': {"uid": deviceIds}
// //       }).eq('user_id', currentUserUid);
// //       await UsersRecord.collection
// //           .doc(currentUserUid)
// //           .update({"fcmTokens": deviceIds});
// //     });
// //   }
// // }
//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// import '../backend/authentication/auth_util.dart';
// import '../backend/schema/users_record.dart';
// import '../backend/supabase/Supabase.dart';
// import 'device_info.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   void initLocalNotifications(RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//
//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(message);
//     });
//   }
//
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (Platform.isAndroid) {
//         initLocalNotifications(message);
//         showNot(message);
//       }
//       if (Platform.isIOS) {
//         initLocalNotifications(message);
//         showNot(message);
//       }
//     });
//   }
//
//   void handleMessage(RemoteMessage message) {}
//
//   Future<void> setupInteractMessage(BuildContext context) async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // when app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       handleMessage(initialMessage);
//     }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(event);
//     });
//   }
//
//   Future<void> showNot(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       showBadge: true,
//     );
//
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name.toString(),
//       channelDescription: 'your channel description',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);
//
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: darwinNotificationDetails,
//     );
//
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         message.notification!.hashCode,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }
//
//   notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'channelId',
//           'channelName',
//           importance: Importance.max,
//           playSound: true,
//         ),
//         iOS: DarwinNotificationDetails());
//   }
//
//   Future sendNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return _flutterLocalNotificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }
//
//   Future scheduleNotification(
//       {int id = 0,
//       String? title,
//       String? body,
//       required DateTime scheduledNotificationDateTime}) async {
//     return _flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(
//           scheduledNotificationDateTime,
//           tz.local,
//         ),
//         await notificationDetails(),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }
//
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//   DeviceInformation deviceInformation = DeviceInformation();
//
//   Future<void> saveFcmToFireBase(String fcmToken) async {
//     DocumentSnapshot data =
//         await UsersRecord.collection.doc(currentUserUid).get();
//     await SupaFlow.client
//         .from('users')
//         .select()
//         .eq('user_id', currentUserUid)
//         .execute();
//     Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;
//     dynamic deviceIds = dataMap["fcmTokens"];
//     firebaseMessaging.subscribeToTopic("ALL");
//     deviceInformation.getDeviceInfo().then((value) async {
//       deviceIds = fcmToken.toString();
//
//       // deviceIds[value.toString()] = fcmToken.toString();
//       await SupaFlow.client.from('users').update({
//         'firebase_token': {"uid": deviceIds}
//       }).eq('user_id', currentUserUid);
//       await UsersRecord.collection
//           .doc(currentUserUid)
//           .update({"fcmTokens": deviceIds});
//     });
//   }
// }

// import 'dart:developer';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:gamer/backend/supabase/supabase.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../constants/routes_constants.dart';
// import '../../services/Helper.dart';
// class login {
//
//   Future<void> googleSignIn() async {
//     final googleSignIn = GoogleSignIn();
//     final googleAccount = await googleSignIn.signIn();
//     if (googleAccount != null) {
//       final googleAuth = await googleAccount.authentication;
//       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//         try {
//           final authResult = await authFirebase.signInWithCredential(
//             GoogleAuthProvider.credential(
//                 idToken: googleAuth.idToken,
//                 accessToken: googleAuth.accessToken),
//           );
//           if (authResult.additionalUserInfo!.isNewUser) {
//             // Create the referral ID by combining the first name and random characters
//
//             SupaFlow.client.from('customer_users').insert({
//               'name': authFirebase.currentUser!.displayName.toString(),
//               'email': authFirebase.currentUser!.email.toString(),
//               'photo_url': authFirebase.currentUser!.photoURL.toString(),
//               'user_id': authFirebase.currentUser!.uid.toString(),
//               'referal_id': referralId,
//             }).then((value) {
//               context.go(RouteConstants.home);
//             }).onError((error, stackTrace) {
//               print(error.toString());
//             });
//           } else {
//             if (await Permission.location.isGranted) {
//               context.go(RouteConstants.home);
//             } else {
//               context.go('/locationPerScreen');
//             }
//           }
//         } catch (e) {
//           log(e.toString());
//         }
//       }
//     }
//   }
// }

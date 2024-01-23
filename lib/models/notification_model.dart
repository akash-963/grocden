// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationService {
//   late Future<String?> userId = getUserId();
//
//   final CollectionReference<Map<String, dynamic>> notificationsCollection =
//   FirebaseFirestore.instance.collection('userCollection/${userId}/notifications/');
//
//   Future<List<NotificationModel>> fetchNotifications() async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> snapshot =
//       await notificationsCollection.get();
//
//       return snapshot.docs.map((doc) {
//         return NotificationModel.fromJson(doc.data());
//       }).toList();
//     } catch (e) {
//       print('Error fetching notifications: $e');
//       return [];
//     }
//   }
// }
//
// String getUserId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('userId');
// }
//
// class NotificationModel {
//   final String title;
//   final String body;
//   final String? imageUrl;
//   final String? clickAction;
//   final Timestamp timestamp;
//
//   NotificationModel({
//     required this.title,
//     required this.body,
//     this.imageUrl,
//     this.clickAction,
//     required this.timestamp,
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       title: json['title'] ?? '',
//       body: json['body'] ?? '',
//       imageUrl: json['imageUrl'],
//       clickAction: json['clickAction'],
//       timestamp: json['timestamp'] ?? Timestamp.now(),
//     );
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      String? userId = await getUserId();
      if (userId == null) {
        // Handle the case where userId is null (e.g., user not logged in)
        return [];
      }

      final CollectionReference<Map<String, dynamic>> notificationsCollection =
      FirebaseFirestore.instance.collection('userCollection/$userId/notifications/');

      QuerySnapshot<Map<String, dynamic>> snapshot =
      await notificationsCollection.get();

      return snapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}

class NotificationModel {
  final String title;
  final String body;
  final String? imageUrl;
  final String? clickAction;
  final Timestamp timestamp;

  NotificationModel({
    required this.title,
    required this.body,
    this.imageUrl,
    this.clickAction,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'],
      clickAction: json['clickAction'],
      timestamp: json['timestamp'] ?? Timestamp.now(),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class NotificationsTab extends StatelessWidget {
//   const NotificationsTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Notifications Tab'),
//     );
//   }
// }













import 'package:flutter/material.dart';

import '../models/notification_model.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModel>>(
      future: NotificationService().fetchNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while fetching data
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<NotificationModel> notifications = snapshot.data ?? [];

        if (notifications.isEmpty) {
          return Center(child: Text('No notifications found.'));
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(notification.imageUrl ?? ''),
              ),
              title: Text(notification.title),
              subtitle: Text(notification.body),
              // You can customize the UI based on your notification model
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),

      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: NotificationService().fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator while fetching data
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<NotificationModel> notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(child: Text('No notifications found.'));
          }

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 3);
            },
            padding: EdgeInsets.all(4),
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Color(0xff9fe2bf),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(notification.imageUrl ?? ''),
                  ),
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  // You can customize the UI based on your notification model
                ),
              );
            },
          );
        },
      ),
    );
  }
}

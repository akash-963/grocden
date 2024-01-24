import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import '../../pages/order_details_page.dart';

// class OrderTile extends StatelessWidget {
//   final MyOrder order;
//
//   const OrderTile({Key? key, required this.order}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8.0),
//       child: ListTile(
//         title: Text('Order ID: '),
//         //${order.orderId}'),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Shop: ${order.shop}'),
//             Text('Buyer: ${order.buyer}'),
//             Text('Total Value: ${order.totalValue}'),
//             Text('Status: ${order.status}'),
//             Text('Created Date: ${order.createdTimestamp.toDate()}'),
//             if (order.deliveredTimestamp != null)
//               Text('Delivered Date: ${order.deliveredTimestamp!.toDate()}'),
//             if (order.cancelledTimestamp != null)
//               Text('Cancelled Date: ${order.cancelledTimestamp!.toDate()}'),
//             // Display other order details as needed
//           ],
//         ),
//         onTap: () {
//           // Handle the tap event, e.g., navigate to a detailed order view
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OrderDetailsPage(order: order),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }





class OrderTile extends StatelessWidget {
  final MyOrder order;

  const OrderTile({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: ListTile(
          leading: Image.asset("assets/images/17727433.jpg"),
          title: Row(children: [
              Text('Order ID: '),
              //Text("")
          ]),
          //${order.orderId}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date : ${order.createdTimestamp.toDate()}"),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Value: \₹ ${order.totalValue}'),
                  Text('Status: ${order.status}'),
                ],
              ),
            ]
          ),
          onTap: () {
            // Handle the tap event, e.g., navigate to a detailed order view
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailsPage(order: order),
              ),
            );
          },
        ),
      ),
    );
  }
}
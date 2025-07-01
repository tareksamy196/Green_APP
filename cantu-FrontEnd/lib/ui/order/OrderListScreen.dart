import 'package:cantu/data/ApiService.dart';
import 'package:flutter/material.dart';

import 'OrderDetailsScreen.dart';
import 'PaymentScreen.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;
  ApiService api = ApiService();
  @override
  void initState() {
    super.initState();
    _ordersFuture = api.fetchAllOrders();
  }

  void _navigateToOrderScreen(BuildContext context, Map<String, dynamic> order) {
    if (order['status'] == 'pending' && order['address'] == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(orderId: order['id']),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(orderId: order['id']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text('Orders'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          } else {
            final orders = snapshot.data!;
            print('orders: '+orders.length.toString());
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () => _navigateToOrderScreen(context, order),
                  child: Card(
                    color: Colors.green.shade100,
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order['id']}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.0),
                          Text('Total Amount: \$${order['total_amount']}'),
                          Text('Status: ${order['status']}'),
                          Text('Address: ${order['address'] ?? 'N/A'}'),
                          Text('Created At: ${order['created_at']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

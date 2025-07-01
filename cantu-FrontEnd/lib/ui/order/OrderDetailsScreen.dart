import 'package:cantu/data/ApiService.dart';
import 'package:cantu/data/model/OrderModel.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<Order> _orderFuture;

  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _orderFuture = api.fetchOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Text('Order Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Order>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load order'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No order details available'));
          } else {
            final order = snapshot.data!;
            final items = order.items;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${order.id}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 5.0),
                          Text('Total Amount: \$${order.totalAmount}',
                              style: TextStyle(fontSize: 16)),
                          Text('Status: ${order.status}',
                              style: TextStyle(fontSize: 16)),
                          Text('Address: ${order.address ?? 'N/A'}',
                              style: TextStyle(fontSize: 16)),
                          Text('Created At: ${order.createdAt}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  Text('Items:',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  if (items != null)
                    ...items.map<Widget>((item) {
                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: EdgeInsets.only(top: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                item.pic,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      item.description,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Quantity: ${item.quantity}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                  else
                    Text('No items available',
                        style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

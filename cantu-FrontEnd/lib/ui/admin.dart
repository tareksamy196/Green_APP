import 'package:flutter/material.dart';
import 'package:cantu/data/ApiService.dart';

import '../data/model/Request.dart';

class ProductDashboard extends StatefulWidget {
  const ProductDashboard({super.key});

  @override
  _ProductDashboardState createState() => _ProductDashboardState();
}

class _ProductDashboardState extends State<ProductDashboard> {
  late Future<List<Request>> _requests;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _requests = api.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Dashboard'),
        actions: [
          DropdownButton<String>(
            value: 'All',
            items: ['All', 'pending', 'approved', 'canceled'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              // Filter logic here
            },
          ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {

          },
        ),
      ),

        ],
      ),
      body: FutureBuilder<List<Request>>(
        future: _requests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load requests: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No requests available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var request = snapshot.data![index];
              return RequestCard(
                request: request,
                onApprove: () => _confirmAction(context, request, 'approve'),
                onCancel: () => _rejectRequest(context, request, 'cancel'),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmAction(BuildContext context, Request request, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this request?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final success = await api.approveRequest(request.id.toString());
                if(success) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }


  void _rejectRequest(BuildContext context, Request request, String action) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this request?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                final success = await api.rejectRequest(request.id.toString());
                if(success) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback onApprove;
  final VoidCallback onCancel;

  RequestCard({required this.request, required this.onApprove, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: request.status != 'canceled',
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 5,
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          leading: request.pic.isNotEmpty
              ? Image.network(request.pic, width: 50, height: 50, fit: BoxFit.cover)
              : Icon(Icons.image, size: 50, color: Colors.grey),
          title: Text(request.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(request.categoryName, style: TextStyle(color: Colors.grey[700])),
              SizedBox(height: 5),
              Text('Brand: ${request.brandName}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Text('\$${request.price}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              SizedBox(height: 5),
              Text(
                'Status: ${request.status}',
                style: TextStyle(
                  color: getStatusColor(request.status),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: onApprove,
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: onCancel,
              ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetailPage(request: request)),
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class ProductDetailPage extends StatelessWidget {
  final Request request;

  ProductDetailPage({required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(request.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Text(request.categoryName, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Brand:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Text(request.brandName, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Price: \$${request.price}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 20),
            Text('Status:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 10),
            Text(
              request.status,
              style: TextStyle(
                color: getStatusColor(request.status),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<Request> requests;
  final Function(String) onQueryChanged;

  ProductSearchDelegate(this.requests, this.onQueryChanged);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged('');
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = requests.where((request) {
      return request.name.toLowerCase().contains(query.toLowerCase()) || request.categoryName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var request = results[index];
        return ListTile(
          title: Text(request.name),
          subtitle: Text(request.categoryName),
          trailing: Text('\$${request.price}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailPage(request: request)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = requests.where((request) {
      return request.name.toLowerCase().contains(query.toLowerCase()) || request.categoryName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var request = suggestions[index];
        return ListTile(
          title: Text(request.name),
          subtitle: Text(request.categoryName),
          trailing: Text('\$${request.price}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetailPage(request: request)),
            );
          },
        );
      },
    );
  }
}

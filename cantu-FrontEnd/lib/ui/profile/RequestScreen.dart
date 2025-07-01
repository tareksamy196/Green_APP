
import 'package:flutter/material.dart';
import 'package:cantu/data/ApiService.dart'; // Update with correct import path
import 'package:cantu/data/model/Request.dart'; // Replace with your model imports

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  ApiService _apiService = ApiService();

  List<Request> _requests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRequests(); // Fetch requests when screen initializes
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Request> requests = await _apiService.fetchRequests();
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Handle error: Show a snackbar or display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch requests: $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildRequestList(),
    );
  }

  Widget _buildRequestList() {
    return ListView.builder(
      itemCount: _requests.length,
      itemBuilder: (context, index) {
        Request request = _requests[index];
        return ListTile(
          title: Text(request.name),
          subtitle: Text('Status: ${request.status}'),
          onTap: () {
            // Implement onTap behavior here, e.g., navigate to request details
            _navigateToRequestDetails(request);
          },
        );
      },
    );
  }

  void _navigateToRequestDetails(Request request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestDetailsScreen(request: request),
      ),
    );
  }
}

class RequestDetailsScreen extends StatelessWidget {
  final Request request;

  const RequestDetailsScreen({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Category: ${request.categoryName}'),
            SizedBox(height: 8),
            Text('Brand: ${request.brandName}'),
            SizedBox(height: 8),
            Text('Price: ${request.price}'),
            SizedBox(height: 8),
            Text('Quantity: ${request.quantity}'),
            SizedBox(height: 8),
            Text('Status: ${request.status}'),
            SizedBox(height: 8),
            Text('Requested by: ${request.userName}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:cantu/data/model/CartModel.dart';
import 'package:cantu/data/model/Request.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../firebase_options.dart';
import 'model/BrandModel.dart';
import 'model/Category.dart' as category;
import 'model/OrderModel.dart';
import 'model/Product.dart';
import 'model/profileModel.dart';
import 'model/wishlist.dart';

class ApiService {
  static final ApiService _apiService = ApiService._internal();
  late String baseUrl;
  late SharedPreferences prefs;

  factory ApiService() {
    return _apiService;
  }

  ApiService._internal();

  initApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await connectDatabase();
    //baseUrl = "https://a961-196-158-193-221.ngrok-free.app";
    prefs = await SharedPreferences.getInstance();
  }

  connectDatabase() async {
    FirebaseApp app = Firebase.app();
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
        app: app,
        databaseURL:
            'https://cantu-53347-default-rtdb.europe-west1.firebasedatabase.app/');
    DatabaseReference ref = database.ref();
    print("snapshotting");
    try {
      final snapshot = await ref.child('baseurl').get();
      print("after");
      if (snapshot.exists) {
        baseUrl = snapshot.value.toString();
        if (kDebugMode) {
          print('Base URL: $baseUrl');
        }
      } else {
        if (kDebugMode) {
          print('Snapshot does not exist.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching base URL: $e');
      }
    }
  }

  Future<bool> login(String email, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('$baseUrl/cantu-backend/app/auth/login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': pass}),
    );

    if (response.statusCode == 200) {
      String accessToken = response.headers['authorization'] ?? "";
      await prefs.setString('access_token', accessToken);
    }
    return response.statusCode == 200;
  }

  Future<bool> signup(
      String username, String email, String phone, String pass) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cantu-backend/app/auth/signup.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': pass,
        'phone': phone,
        'username': username
      }),
    );
    if (response.statusCode == 200) {
      String accessToken = response.headers['authorization'] ?? "";

      await prefs.setString('access_token', accessToken);
    }
    return response.statusCode == 200;
  }

  Future<Profile?> fetchProfile() async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
        Uri.parse('$baseUrl/cantu-backend/app/auth/user.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      String accessToken = response.headers['authorization'] ?? "";

      await prefs.setString('access_token', accessToken);
      return Profile.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<category.Category>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('$baseUrl/cantu-backend/app/product/categories.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => category.Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Brand>> fetchBrands(String categoryId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/cantu-backend/app/product/brandsByCategory.php?categoryId=$categoryId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Brand.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<void> createRequest(String name, int categoryId, int brandId,
      double price, int quantity, String imageUrl) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.post(
      Uri.parse('$baseUrl/cantu-backend/app/product/createRequest.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'categoryId': categoryId,
        'brandId': brandId,
        'price': price,
        'quantity': quantity,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      // Handle the response here, e.g., by parsing the JSON
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('product_id')) {
        print('Product created with ID: ${responseData['product_id']}');
      } else {
        throw Exception('Failed to create product: ${responseData['error']}');
      }
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse('$baseUrl/cantu-backend/app/product/products.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Request>> fetchRequests() async {
    final response = await http
        .get(Uri.parse('$baseUrl/cantu-backend/app/product/requests.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data);
      return data.map((json) => Request.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Request> fetchRequest(String id) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/cantu-backend/app/product/requestById.php?request_id=$id'));

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      return data.map((json) => Request.fromJson(json));
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<bool> approveRequest(String id) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cantu-backend/app/product/approveRequest.php?request_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

    if (response.statusCode == 200) {
      return response.statusCode == 200;
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<bool> rejectRequest(String id) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cantu-backend/app/product/rejectRequest.php?request_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

    if (response.statusCode == 200) {
      return response.statusCode == 200;
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> fetchProduct(String id) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/cantu-backend/app/product/productById.php?product_id=$id'));

    print(response.body);
    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/cantu-backend/app/product/productByCategory.php?category_id=$categoryId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<bool> addProductToFavorite(int productId) async {
    String accessToken = prefs.getString('access_token') ?? "";

    final response = await http.get(
        Uri.parse(
            '$baseUrl/cantu-backend/app/wishlist/add_to_wishlist.php?product_id=$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

     return response.statusCode == 200;
  }

  Future<bool> fetchFavoriteByProductId(int productId) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cantu-backend/app/wishlist/get_wishlist_item.php?product_id=$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

    return response.statusCode == 200;
  }

  Future<bool> removeFromFavorite(int productId) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cantu-backend/app/wishlist/remove_from_wishlist.php?product_id=$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

    return response.statusCode == 200;
  }

  Future<void> addToCart(int productId, int quantity) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.post(
      Uri.parse('$baseUrl/cantu-backend/app/order/add_to_cart.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken

      },
      body: jsonEncode(<String, dynamic>{
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to cart');
    }
  }



  Future<int?> checkout() async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.post(
      Uri.parse('$baseUrl/cantu-backend/app/order/create_order.php?'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['order_id'];
    } else {
      return null;
    }
  }

  Future<Cart> fetchCartItems() async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
      Uri.parse('$baseUrl/cantu-backend/app/order/view_cart.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken,
      },
    );
    if (response.statusCode == 200) {
      return Cart.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load cart data');
    }
  }
   Future<bool> removeFromCart(int productId) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cantu-backend/app/cart/delete.php?product_id=$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> deleteCartItem(int productId, int quantity) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.post(
        Uri.parse('$baseUrl/cantu-backend/app/order/manage_cart.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': accessToken
        },
        body: jsonEncode(<String, String>{
        'quantity': quantity.toString(),
        'product_id':productId.toString(),
        'action': 'delete'
        }));

    return response.statusCode == 200;
  }

  Future<bool> updateCartItemQuantity(int productId, int quantity) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.post(
      Uri.parse('$baseUrl/cantu-backend/app/order/manage_cart.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
      body: jsonEncode(<String, String>{
        'quantity': quantity.toString(),
        'product_id':productId.toString(),
        'action': 'update'
      }),
    );

    return response.statusCode == 200;
  }

  Future<Order> fetchOrderById(int orderId) async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
      Uri.parse('$baseUrl/cantu-backend/app/order/view_order.php?order_id=$orderId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body)['order']);
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllOrders() async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
      Uri.parse('$baseUrl/cantu-backend/app/order/view_order.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      return List<Map<String, dynamic>>.from(responseBody['orders']);
    } else {
      throw Exception('Failed to load orders');
    }
  }


  Future<bool> placeOrder(String address,String paymentMethod,int orderId) async {
    String accessToken = prefs.getString('access_token') ?? "";

    String apiUrl = '$baseUrl/cantu-backend/app/order/update_checkout.php'; // Replace with your PHP API endpoint

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      // Add your access token if required
       'Authorization': accessToken
    };

    Map<String, dynamic> body = {
      'address': address,
      'payment_method': paymentMethod,
      'order_id': orderId
    };

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String orderId = responseData['order_id'].toString();

        // Navigate to success screen with orderId
       return true;
      } else {
        // Handle errors based on response.statusCode
        print('Failed to place order: ${response.body}');
       return false;
      }
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }

  Future<List<WishlistItem>> fetchWishlistItems() async {
    String accessToken = prefs.getString('access_token') ?? "";
    final response = await http.get(
      Uri.parse('$baseUrl/cantu-backend/app/wishlist/wishlist_items.php'),
      headers: {
        'Authorization': accessToken, // Replace with actual token
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['wishlist_items'];
      return body.map((dynamic item) => WishlistItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load wishlist items');
    }
  }

}

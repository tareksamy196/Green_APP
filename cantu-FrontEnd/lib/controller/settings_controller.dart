import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  final int user_id;
  final String username;
  final String email;

  const Profile(
      {required this.user_id, required this.email, required this.username});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user_id: json['user_id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Profile> profile;

  Future<Profile> fetchProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        'https://87a8-197-135-128-61.ngrok-free.app/cantu-backend/app/auth/login.php?id=1'));

    if (response.statusCode == 200) {
      print(response.body);
      String accessToken = response.headers['X-Auth-Token'] ?? "";

      await prefs.setString('access_token', accessToken);
      return Profile.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  @override
  void initState() {
    super.initState();
    profile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.width / 3,
                color: Colors.blue, // Use your desired color
              ),
              Positioned(
                top: MediaQuery.of(context).size.width / 3.9,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[100],
                    // Use your desired image
                    backgroundImage: AssetImage('assets/profile_image.png'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    trailing: Switch(
                      onChanged: (val) {},
                      value: true,
                    ),
                    title: Text("Disable Notifications"),
                  ),
                  ListTile(
                    onTap: () {},
                    trailing: Icon(Icons.location_on_outlined),
                    title: Text("Address"),
                  ),
                  ListTile(
                    onTap: () {},
                    trailing: Icon(Icons.help_outline_rounded),
                    title: Text("About us"),
                  ),
                  ListTile(
                    onTap: () {},
                    trailing: Icon(Icons.phone_callback_outlined),
                    title: Text("Contact us"),
                  ),
                  ListTile(
                    onTap: () {
                      logout();
                    },
                    title: Text("Logout"),
                    trailing: Icon(Icons.exit_to_app),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    // Navigate to login screen or do any other required actions after logout
  }
}

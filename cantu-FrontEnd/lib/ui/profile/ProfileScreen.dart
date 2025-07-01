import 'package:cantu/data/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/profileModel.dart';
import '../order/OrderListScreen.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Profile?> profile;
  late final ApiService apiService;

  void _navigateToOrderList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderListScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    profile = apiService.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 2.5,
              color: Colors.amber, // Use your desired color
            ),
            Positioned(
              top: MediaQuery.of(context).size.width / 3.9,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[100],
                  // Use your desired image
                  backgroundImage: const AssetImage('assets/images/c.jpeg'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  trailing: Switch(
                    onChanged: (val) {},
                    value: true,
                    activeColor: const Color.fromARGB(255, 3, 131, 5),
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
                ListTile(
                  onTap: () {
                    _navigateToOrderList(context);
                  },
                  title: Text("View Orders"),
                  trailing: Icon(Icons.list),
                ),

              ],
            ),
          ),
        )
      ],
    );
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Navigator.pushNamed(context, '/');
  }
}
//profile
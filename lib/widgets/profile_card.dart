import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/login/provider/login_provider.dart';
import '../utility/constants.dart';

class ProfileCard extends StatelessWidget {
  final String? userName;

  const ProfileCard({
    Key? key,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: PopupMenuButton<String>(
        offset: Offset(0, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: secondaryColor,
        icon: Row(
          children: [
            Image.asset(
              "assets/images/profile_pic.png",
              height: 38,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(userName ?? "Admin User"),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
        onSelected: (value) async {
          if (value == 'logout') {
            final loginProvider = Provider.of<LoginProvider>(context, listen: false);
            await loginProvider.logout();
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.white, size: 20),
                SizedBox(width: defaultPadding / 2),
                Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

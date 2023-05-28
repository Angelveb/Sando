import 'package:flutter/material.dart';
import 'package:login/componentes/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  const MyDrawer({super.key,
  required this.onProfileTap,
  required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            //header
           const DrawerHeader(
           child: Icon(
            Icons.person,
            color: Colors.white,
            size: 64,
            ),
          ),

          //home list tile
          MyListTile(icon: Icons.home, 
          text: 'I N I C I O',
          onTap: () => Navigator.pop(context),
          ),

          // profile list tile
          MyListTile(
            icon: Icons.person_3, 
            text: 'P E R F I L', 
            onTap: onProfileTap,
            ),
          ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout, 
              text: 'S A L I R', 
              onTap: onSignOut,
              ),
          ),
        ],
        ),
    );
  }
}
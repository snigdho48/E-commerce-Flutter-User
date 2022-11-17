import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/pages/launcher_page.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/cart_page.dart';
import '../pages/user_profile_page.dart';
import '../utils/ThemeUtils.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child:

      ListView(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                if (!AuthService.currentUser!.isAnonymous)
                Card(
                  elevation: 5,
                  child:userProvider.userModel!.imageUrl == null
                      ? const Icon(
                    Icons.person,
                    size: 90,
                    color: Colors.grey,
                  )
                      : CachedNetworkImage(
                    width: 90,
                    height: 90,
                    imageUrl: userProvider.userModel!.imageUrl!,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                if (!AuthService.currentUser!.isAnonymous)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.userModel!.displayName ?? 'No Display Name',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      userProvider.userModel!.email,
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!AuthService.currentUser!.isAnonymous)
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          if (!AuthService.currentUser!.isAnonymous)
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, CartPage.routeName);
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
          ),
          if (!AuthService.currentUser!.isAnonymous)
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.monetization_on),
            title: const Text('My Orders'),
          ),
          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LauncherPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
          ListTile(
            onTap: (){
              ThemeServices().swtichTheme();
            },
            leading: ThemeServices().loadTheme()?const Icon(Icons.sunny):const Icon(Icons.nightlight_round),
            title: ThemeServices().loadTheme()? const Text('Light Theme'):const Text('Dark Theme'),
          ),

        ],
      ),
    );
  }
}

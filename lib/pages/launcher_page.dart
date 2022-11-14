import 'package:ecom_user_07/pages/view_product_page.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'login_page.dart';

class LauncherPage extends StatelessWidget {
  static const String routeName = '/';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if(AuthService.currentUser != null) {
        Navigator.pushReplacementNamed(context, ViewProductPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}

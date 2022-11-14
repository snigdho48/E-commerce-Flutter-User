import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:ecom_user_07/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/user_model.dart';
import 'launcher_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = '';
  late UserProvider userProvider;

  @override
  void initState() {
    _passwordController.text = '123456';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _authenticate(true);
                },
                child: const Text('Login'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User? '),
                  TextButton(
                    onPressed: () {
                      _authenticate(false);
                    },
                    child: const Text('Register here'),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _errMsg,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              ListTile(
                onTap: () {
                  _signInWithGoogleAccount();
                },
                leading: const Icon(Icons.g_mobiledata),
                title: const Text('SIGIN IN WITH GOOGLE'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Login as Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate(bool tag) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        if (tag) {
          await AuthService.login(email, password);
        } else {
          await AuthService.register(email, password);
        }
        if (!tag) {
          final userModel = UserModel(
            userId: AuthService.currentUser!.uid,
            email: AuthService.currentUser!.email!,
            userCreationTime: Timestamp.fromDate(
                AuthService.currentUser!.metadata.creationTime!),
          );
          userProvider.addUser(userModel).then((value) {
            EasyLoading.dismiss();
            if (mounted) {
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            }
          }).catchError((error) {
            EasyLoading.dismiss();
            showMsg(context, 'could not save user info');
          });
        }
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _signInWithGoogleAccount() async {
    try {
      final credential = await AuthService.signInWithGoogle();
      final userExists = await userProvider.doesUserExist(credential.user!.uid);
      if (!userExists) {
        EasyLoading.show(status: 'Redirecting user...');
        final userModel = UserModel(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          userCreationTime: Timestamp.fromDate(DateTime.now()),
          displayName: credential.user!.displayName,
          imageUrl: credential.user!.photoURL,
          phone: credential.user!.phoneNumber,
        );
        await userProvider.addUser(userModel);
        EasyLoading.dismiss();
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, LauncherPage.routeName);
      }
    } catch (error) {
      EasyLoading.dismiss();
      rethrow;
    }
  }
}

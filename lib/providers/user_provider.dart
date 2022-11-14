import 'dart:io';
import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/db/db_helper.dart';
import 'package:ecom_user_07/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(UserModel userModel) => DbHelper.addUser(userModel);

  Future<bool> doesUserExist(String uid) => DbHelper.doesUserExist(uid);


  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if (snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateUserProfileField(String field, dynamic value) =>
      DbHelper.updateUserProfileField(
          AuthService.currentUser!.uid, {field: value});

  Future<String> uploadImage(String path) async {
    final imageName = 'pro_${DateTime.now().millisecondsSinceEpoch}';
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('$firebaseStorageProductImageDir/$imageName');
    final uploadTask = imageRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    print('${snapshot.ref.getDownloadURL()}');
    return await snapshot.ref.getDownloadURL();

  }

  Future<void> deleteImage(String url) {
    return FirebaseStorage.instance.refFromURL(url).delete();
  }
}

import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

Future<bool> isConnectedToInternet() async {
  var result = await (Connectivity().checkConnectivity());
  return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}

showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(msg)));

getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) =>
    DateFormat(pattern).format(dt);



 getImage(UserProvider userProvider, BuildContext context) async {
   const ImageSource imageSource = ImageSource.gallery;
   final pickedImage = await ImagePicker().pickImage(source: imageSource, imageQuality: 70,);
   final presentimage= userProvider.userModel!.imageUrl;

try{
  if(pickedImage != null) {
    EasyLoading.show(status: 'Uploading...');
    final imageModel = await userProvider.uploadImage(pickedImage.path);
    userProvider.updateUserProfileField('imageUrl', imageModel);
    if(presentimage !=null){
      userProvider.deleteImage(presentimage);
    }
    EasyLoading.dismiss();
    showMsg(context, 'Upload Successful');
  }
}catch(error){
  EasyLoading.dismiss();
}

}

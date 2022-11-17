import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/models/user_model.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:ecom_user_07/utils/helper_functions.dart';
import 'package:ecom_user_07/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../models/address_model.dart';
import '../utils/widget_city.dart';
import '../utils/widget_gender.dart';
import '../utils/widget_map.dart';
import 'otp_verification_page.dart';

class UserProfilePage extends StatelessWidget {
  static const String routeName = '/profile';

  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Profile'),
      ),
      body: userProvider.userModel == null
          ? const Center(
        child: Text('Failed to load user data'),
      )
          : ListView(
        children: [
          _headerSection(context, userProvider),
          ListTile(
            leading: const Icon(Icons.call),
            title: Text(userProvider.userModel!.phone?.substring(3,14) ?? 'Not set yet'),
            trailing: IconButton(
              onPressed: () {
                showSingleTextFieldInputDialog(
                  context: context,
                  title: 'Mobile Number',
                  onSubmit: (value) async {
                    if((value.length==11 && int.tryParse(value)!=null)
                        || (value.length==14 && int.tryParse(value..substring(1,14))!=null))
                    {
                      await Navigator.pushNamed(
                          context, OtpVerificationPage.routeName,
                          arguments: value.startsWith('+',0)?value:"+88$value").then((value)
                      {
                        print(value.toString());
                        // if(value!['isvarified']){
                        //   userProvider.updateUserProfileField('phone', value['phone']);
                        // }
                      });

                    }else{
                      showMsg(context, 'Enter Valid Phone Number');
                    }

                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(userProvider.userModel!.age ?? 'Not set yet'),
            subtitle: const Text('Date of Birth'),
            trailing: IconButton(
              onPressed: () {
                selectDate(context,userProvider);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(userProvider.userModel!.gender ?? 'Not set yet'),
            subtitle: const Text('Gender'),
            trailing: IconButton(
              onPressed: () {
                showGenderInputDialog(context: context,
                    title: 'Select Gender',
                    onSubmit: (value) {
                      userProvider.updateUserProfileField('gender', value);
                    });
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(
                userProvider.userModel!.addressModel?.addressLine1 ??
                    'Not set yet'),
            subtitle: const Text('Address Line 1'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showMapInputDialog(
                        context: context,
                        title: 'Select Location',
                        onSubmit: (value,map) {
                          value=value.split(map['city'])[0];
                          EasyLoading.show(status: 'Please wait');
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldAddressLine1',
                              value.substring(0,value.length-2));
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldCity',
                              map['city']);
                          userProvider.updateUserProfileField(
                              '$userFieldAddressModel.$addressFieldZipcode',
                              map['postcode']);

                          EasyLoading.dismiss();
                        });
                  },
                  icon: const Icon(Icons.location_on),
                ),
                IconButton(
                  onPressed: () {
                    showSingleTextFieldInputDialog(
                      context: context,
                      title: 'Set Address Line 1',
                      onSubmit: (value) {
                        userProvider.updateUserProfileField(
                            '$userFieldAddressModel.$addressFieldAddressLine1',
                            value);
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(
                userProvider.userModel!.addressModel?.addressLine2 ??
                    'Not set yet'),
            subtitle: const Text('Address Line 2'),
            trailing: IconButton(
              onPressed: () {
                showSingleTextFieldInputDialog(
                  context: context,
                  title: 'Set Address Line 2',
                  onSubmit: (value) {
                    userProvider.updateUserProfileField(
                        '$userFieldAddressModel.$addressFieldAddressLine2',
                        value);
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(userProvider.userModel!.addressModel?.city ??
                'Not set yet'),
            subtitle: const Text('City'),
            trailing: IconButton(
              onPressed: () {
                showCityInputDialog(context: context,
                    title: 'Select City',
                    onSubmit: (value ) {
                  if(value.split(',').length==3){
                    userProvider.updateUserProfileField('$userFieldAddressModel.$addressFieldCity', value.split(',')[2]);

                  }else{
                    userProvider.updateUserProfileField('$userFieldAddressModel.$addressFieldCity', value);
                  }
                    });
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(userProvider.userModel!.addressModel?.zipcode ??
                'Not set yet'),
            subtitle: const Text('Zip Code'),
            trailing: IconButton(
              onPressed: () {
                showSingleTextFieldInputDialog(
                  context: context,
                  title: 'Set Zip Code',
                  onSubmit: (value) {
                    int.tryParse(value) != null?
                    userProvider.updateUserProfileField(
                        '$userFieldAddressModel.$addressFieldZipcode',
                        value):
                    showMsg(context, 'Please Enter valid Code');
                  },
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  Container _headerSection(BuildContext context, UserProvider userProvider) {
    return Container(
      height: 150,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 5,
                child: userProvider.userModel!.imageUrl == null
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
              TextButton(
                  style: TextButton.styleFrom(fixedSize: const Size(90,2),foregroundColor: Colors.white,backgroundColor: Colors.deepPurple),
                  onPressed: (){
                    getImage(userProvider,context);
                  },
                  child: const Text('Update')),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userProvider.userModel!.displayName ?? 'No Display Name',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                  IconButton(
                      onPressed: (){
                        showSingleTextFieldInputDialog(
                            context: context,
                            title: 'Name',
                            onSubmit: (value){
                              userProvider.updateUserProfileField(userFieldDisplayName, value);
                            });
                      },
                      icon: const Icon(Icons.edit,size: 20,)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.userModel!.email,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  IconButton(
                      alignment: Alignment.topLeft,
                      onPressed: (){
                        showSingleTextFieldInputDialog(
                            context: context,
                            title: 'Email',
                            onSubmit: (value){
                              userProvider.updateUserProfileField(userFieldEmail, value);
                            });
                      },
                      icon: const Icon(Icons.edit,size: 15)),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  Future<void> selectDate(BuildContext context, UserProvider userProvider) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime.now(),
    );
    userProvider.updateUserProfileField('age', getFormattedDate(selectedDate!));

  }

}
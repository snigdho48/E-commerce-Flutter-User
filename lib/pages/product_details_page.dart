import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/pages/login_page.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:ecom_user_07/utils/helper_functions.dart';
import 'package:ecom_user_07/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';

  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;
  late UserProvider userProvider;
  late Size size;
  String photoUrl = '';
  double userRating = 0.0;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    photoUrl = productModel.thumbnailImageModel.imageDownloadUrl;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            imageUrl: photoUrl,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    photoUrl =
                        productModel.thumbnailImageModel.imageDownloadUrl;
                  });
                },
                child: Card(
                  child: CachedNetworkImage(
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              ...productModel.additionalImageModels.map((url) {
                return url.isEmpty
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            photoUrl = url;
                          });
                        },
                        child: Card(
                          child: CachedNetworkImage(
                            width: 70,
                            height: 100,
                            fit: BoxFit.fill,
                            imageUrl: url,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
              }).toList()
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  label: const Text('ADD TO FAVORITE'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('ADD TO CART'),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text('Sale Price: $currencySymbol${productModel.salePrice}'),
            subtitle: Text('Discount: ${productModel.productDiscount}%'),
            trailing: Text(
                '$currencySymbol${productProvider.priceAfterDiscount(productModel.salePrice, productModel.productDiscount)}'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rate this Product'),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 0.0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: false,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        userRating = rating;
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (AuthService.currentUser!.isAnonymous) {
                        showCustomDialog(
                          context: context,
                          title: 'Unregistered User',
                          positiveButtonText: 'Login',
                          content:
                              'To rate this product, you need to login with your email and password or Google Account. To login with your account, go to Login Page',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.routeName);
                          },
                        );
                      } else {
                        EasyLoading.show(status: 'Please wait');
                        await productProvider.addRating(
                          productModel.productId!,
                          userRating,
                          userProvider.userModel!,
                        );
                        EasyLoading.dismiss();
                        showMsg(context, 'Thanks for your rating');
                      }
                    },
                    child: const Text('SUBMIT'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/models/product_model.dart';
import 'package:ecom_user_07/utils/ThemeUtils.dart';
import 'package:ecom_user_07/utils/constants.dart';
import 'package:ecom_user_07/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../pages/product_details_page.dart';

class ProductGridItemView extends StatelessWidget {
  final ProductModel productModel;

  const ProductGridItemView({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,
          arguments: productModel),
      child: Card(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: productModel.thumbnailImageModel.imageDownloadUrl,
                    placeholder: (context, url)  =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    productModel.productName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (productModel.productDiscount > 0)
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '$currencySymbol${getPriceAfterDiscount(productModel.salePrice, productModel.productDiscount)}',
                            style: const TextStyle(
                                fontSize: 20,
                            )),
                        Text(
                            ' $currencySymbol${productModel.salePrice}',
                            style: const TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough))

                      ],
                    ),
                  ),
                if (productModel.productDiscount == 0)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      '$currencySymbol${productModel.salePrice}',
                      style: TextStyle(fontSize: 20, color:(ThemeServices().loadTheme()? Colors.black:Colors.white)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: productModel.avgRating.toDouble(),
                        minRating: 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemSize: 20,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                        },
                      ),
                      const SizedBox(width: 5,),
                      Text(productModel.avgRating.toStringAsFixed(1))
                    ],
                  ),
                )
              ],
            ),
            if (productModel.productDiscount > 0)
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  /*transform: Matrix4.identity()..rotateZ(1),
                  transformAlignment: Alignment.center,*/
                  height: 60,
                  color: Colors.black54,
                  child: Text(
                    '${productModel.productDiscount}% OFF',
                    style: TextStyle(fontSize: 25, color:(ThemeServices().loadTheme()? Colors.black:Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

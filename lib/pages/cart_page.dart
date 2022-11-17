import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/ThemeUtils.dart';
import '../utils/widget_cart.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider=Provider.of<CartProvider>(context,listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {},
            child: const Text('CLEAR'),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  var cartModel = provider.cartList[index];
                  cartModel=productProvider.getProductInfoUpdate(cartModel);
                  return cartModel.quantity==0?
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      /*transform: Matrix4.identity()..rotateZ(1),
                  transformAlignment: Alignment.center,*/
                      height: 60,
                      color: (ThemeServices().loadTheme()? Colors.black54:Colors.white54),
                      child: Text(
                        '% OFF',
                        style: TextStyle(fontSize: 25, color:(ThemeServices().loadTheme()? Colors.white:Colors.black)),
                      ),
                    ),
                  )
                      :CartWidget(cartModel);
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Expanded(child: Text('SUBTOTAL: $currencySymbol 23150')),
                    OutlinedButton(
                      onPressed: provider.cartList.isEmpty ? null : () {},
                      child: const Text('CHECKOUT'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

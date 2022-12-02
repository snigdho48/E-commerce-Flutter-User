import 'package:ecom_user_07/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/ThemeUtils.dart';
import '../utils/widget_cart.dart';
import 'checkout_page.dart';



class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
            },
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
                  final cartModel = provider.cartList[index];
                  print(cartModel.quantity);
                  return cartModel.quantity==0?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          /*transform: Matrix4.identity()..rotateZ(1),
                      transformAlignment: Alignment.center,*/
                          height: 120,
                          color: (ThemeServices().loadTheme()? Colors.black54:Colors.white54),
                          child: Text(
                            ' Product Not Available',
                            style: TextStyle(fontSize: 25, color:(ThemeServices().loadTheme()? Colors.white:Colors.black)),
                          ),
                        ),
                      ),
                      CartWidget(
                        cartModel: cartModel,
                        provider: provider,
                      ),

                    ],
                  )
                      :CartWidget(
                    cartModel: cartModel,
                    provider: provider,
                  );
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                            'SUBTOTAL: $currencySymbol${provider.getTotalPrice()}',
                            style: Theme.of(context).textTheme.bodyLarge)),
                    OutlinedButton(
                      onPressed: provider.cartList.isEmpty
                          ? null
                          : () {
                        Navigator.pushNamed(
                            context, CheckoutPage.routeName);
                      },
                      child: const Text(
                        'CHECKOUT',
                      ),
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
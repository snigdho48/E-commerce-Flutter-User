import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/cart_page.dart';
import '../providers/cart_provider.dart';

class CartBubbleView extends StatelessWidget {
  const CartBubbleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, CartPage.routeName),
      child: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.shopping_cart,
              size: 30,
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(1),
              alignment: Alignment.center,
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: Consumer<CartProvider>(
                  builder: (context, provider, child) => Text(
                    '${provider.cartList.length}',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

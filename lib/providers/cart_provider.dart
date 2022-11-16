import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/db/db_helper.dart';
import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  getAllCartItemsByUser() {
    DbHelper.getCartItemsByUser(AuthService.currentUser!.uid)
        .listen((snapshot) {
      cartList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      print(cartList);
      notifyListeners();
    });
  }

  Future<void> addToCart({
    required String productId,
    required String productName,
    required String url,
    required num salePrice,
  }) {
    final cartModel = CartModel(
      productId: productId,
      productName: productName,
      productImageUrl: url,
      salePrice: salePrice,
    );
    return DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
  }

  bool isProductInCart(String productId) {
    final car= List.generate(cartList.length, (index) => cartList[index].productId);
    print(car);
    return car.contains(productId);
  }

  Future<void> removeFromCart(String pid) {
    return DbHelper.removeFromCart(AuthService.currentUser!.uid, pid);
  }
}

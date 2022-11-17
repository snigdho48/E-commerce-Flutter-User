import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/db/db_helper.dart';
import 'package:ecom_user_07/providers/product_provider.dart';
import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../utils/helper_functions.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> cartList = [];

  getAllCartItemsByUser() {
    DbHelper.getCartItemsByUser(AuthService.currentUser!.uid)
        .listen((snapshot) {
      cartList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
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
    final car =
        List.generate(cartList.length, (index) => cartList[index].productId);
    return car.contains(productId);
  }

  Future<void> removeFromCart(String pid) {
    return DbHelper.removeFromCart(AuthService.currentUser!.uid, pid);
  }

  getProductInfoUpdate(CartModel cartModel) {
    CartModel model = cartModel;
    ProductProvider.productList.forEach((element) async {
      if (element.productId == cartModel.productId) {
        num quantity = cartModel.quantity;
        if (quantity > element.stock) {
          quantity = element.stock;
        }
        if (element.available == false) {
          quantity = 0;
        }
        model = CartModel(
            productId: element.productId!,
            productName: element.productName,
            productImageUrl: element.thumbnailImageModel.imageDownloadUrl,
            salePrice: num.parse(getPriceAfterDiscount(
                element.salePrice, element.productDiscount)),
            quantity: quantity);
        // if(model.quantity!= cartModel.quantity || model.salePrice!=cartModel.salePrice){
        //   await DbHelper.addToCart(AuthService.currentUser!.uid, cartModel);
        // }
        final index = cartList
            .indexWhere((element) => element.productId == cartModel.productId);
        cartList.elementAt(index).quantity = model.quantity;
        cartList.elementAt(index).salePrice = model.salePrice;
      }
    });
    return model;
  }

  updateCart(CartModel cartModel, bool value) {
    value ? cartModel.quantity += 1 : cartModel.quantity -= 1;
    notifyListeners();
    return getProductInfoUpdate(cartModel);
  }

  num priceWithQuantity(CartModel cartModel) =>
      cartModel.quantity * cartModel.salePrice;

  num getTotalPrice() {
    num total = 0;
    for (final cartModel in cartList) {
      total += priceWithQuantity(cartModel);
    }
    print(total);
    return total;

  }

  Future<void> clearCart() {
    return DbHelper.clearCart(AuthService.currentUser!.uid, cartList);
  }
}

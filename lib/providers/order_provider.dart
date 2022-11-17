import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/order_constant_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateOrderConstants(OrderConstantModel model) {
    return DbHelper.updateOrderConstants(model);
  }

  int getDiscountAmount(num subtotal) {
    return ((subtotal * orderConstantModel.discount) / 100).round();
  }

  int getVatAmount(num cartSubTotal) {
    final priceAfterDiscount = cartSubTotal - getDiscountAmount(cartSubTotal);
    return ((priceAfterDiscount * orderConstantModel.vat) / 100).round();
  }

  int getGrandTotal(num cartSubTotal) {
    return ((cartSubTotal - getDiscountAmount(cartSubTotal)) +
            getVatAmount(cartSubTotal) +
            orderConstantModel.deliveryCharge)
        .round();
  }
}

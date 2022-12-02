import 'package:ecom_user_07/models/order_model.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/notification_model.dart';
import '../models/order_constant_model.dart';
import '../models/order_item.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
  List<OrderModel> orderList = [];
  List<OrderItem> orderItemList = [];

  getAllOrderByUser() {
    DbHelper.getOrdersByUser(AuthService.currentUser!.uid).listen((snapshot) {
      orderList = List.generate(snapshot.docs.length,
              (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      orderItemList =
          orderList.map((order) => OrderItem(orderModel: order)).toList();
      notifyListeners();
    });
  }

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



  Future<void> saveOrder(OrderModel orderModel) async {
    await DbHelper.saveOrder(orderModel);
    await DbHelper.clearCart(AuthService.currentUser!.uid, orderModel.productDetails);

  }

  Future<void> addNotification(NotificationModel notification) {
    return DbHelper.addNotification(notification);
  }
}


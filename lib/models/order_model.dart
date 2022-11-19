import 'address_model.dart';
import 'cart_model.dart';
import 'date_model.dart';

const String collectionOrder = 'Order';

const String orderFieldOrderId = 'orderId';
const String orderFieldGrandTotal = 'grandTotal';
const String orderFieldDiscount = 'discount';
const String orderFieldVAT = 'VAT';
const String orderFieldOrderStatus = 'orderStatus';
const String orderFieldPaymentMethod = 'paymentMethod';
const String orderFieldOrderDate = 'orderDate';
const String orderFieldDeliveryAddress = 'deliveryAddress';
const String orderFieldProductDetails = 'productDetails';

class OrderModel {
  String orderId;
  String orderStatus;
  String paymentMethod;
  num grandTotal;
  num discount;
  num VAT;
  DateModel orderDate;
  AddressModel deliveryAddress;
  List<CartModel> productDetails;

  OrderModel(
      {required this.orderId,
      required this.orderStatus,
      required this.paymentMethod,
      required this.grandTotal,
      required this.discount,
      required this.VAT,
      required this.orderDate,
      required this.deliveryAddress,
      required this.productDetails});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      orderFieldOrderId: orderId,
      orderFieldOrderStatus: orderStatus,
      orderFieldPaymentMethod: paymentMethod,
      orderFieldGrandTotal: grandTotal,
      orderFieldDiscount: discount,
      orderFieldVAT: VAT,
      orderFieldOrderDate: orderDate.toMap(),
      orderFieldDeliveryAddress: deliveryAddress.toMap(),
      orderFieldProductDetails: List.generate(
          productDetails.length, (index) => productDetails[index].toMap()),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        orderId: map[orderFieldOrderId],
        orderStatus: map[orderFieldOrderStatus],
        paymentMethod: map[orderFieldPaymentMethod],
        grandTotal: map[orderFieldGrandTotal],
        discount: map[orderFieldDiscount],
        VAT: map[orderFieldVAT],
        orderDate: DateModel.fromMap(map[orderFieldOrderDate]),
        deliveryAddress: AddressModel.fromMap(map[orderFieldDeliveryAddress]),
        productDetails: (map[orderFieldProductDetails] as List)
            .map((e) => CartModel.fromMap(e))
            .toList(),
      );
}

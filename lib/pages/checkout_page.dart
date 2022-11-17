import 'package:ecom_user_07/providers/cart_provider.dart';
import 'package:ecom_user_07/providers/order_provider.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:ecom_user_07/utils/ThemeUtils.dart';
import 'package:ecom_user_07/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/helper_functions.dart';
import '../utils/widget_city.dart';
import '../utils/widget_functions.dart';
import '../utils/widget_map.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late OrderProvider orderProvider;
  late CartProvider cartProvider;
  late UserProvider userProvider;
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final zipCodeController = TextEditingController();
  String paymentMethodGroupValue = PaymentMethod.cod;
  String? city;

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    setAddressIfExists();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(9),
        children: [
          buildHeader('Product Info'),
          SizedBox(
              height: cartProvider.cartList.length > 3
                  ? MediaQuery.of(context).size.height * 0.125
                  : MediaQuery.of(context).size.height * 0.2,
              child: ListView(
                children: [
                  buildProductInfoSection(),
                ],
              )),
          buildHeader('Order Summery'),
          buildOrderSummerySection(),
          buildHeader('Delivery Address'),
          buildDeliveryAddressSection(),
          buildHeader('Payment Method'),
          buildPaymentMethodSection(),
          buildOrderButtonSection(),
        ],
      ),
    );
  }

  Padding buildHeader(String header) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        header,
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget buildProductInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: cartProvider.cartList
              .map((cartModel) => ListTile(
                    title: Text(cartModel.productName),
                    trailing:
                        Text('${cartModel.quantity}x${cartModel.salePrice}'),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildOrderSummerySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: const Text('Sub-total'),
              trailing: Text('$currencySymbol${cartProvider.getTotalPrice()}'),
            ),
            ListTile(
              title: Text(
                  'Discount(${orderProvider.orderConstantModel.discount}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getTotalPrice())}'),
            ),
            ListTile(
              title: Text('VAT(${orderProvider.orderConstantModel.vat}%)'),
              trailing: Text(
                  '$currencySymbol${orderProvider.getVatAmount(cartProvider.getTotalPrice())}'),
            ),
            ListTile(
              title: const Text('Delivery Charge'),
              trailing: Text(
                  '$currencySymbol${orderProvider.orderConstantModel.deliveryCharge}'),
            ),
            const Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              title: const Text(
                'Grand Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '$currencySymbol${orderProvider.getGrandTotal(cartProvider.getTotalPrice())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDeliveryAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text(addressLine1Controller.text ?? 'Not set yet'),
              subtitle: const Text('AddressLine 1'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      showMapInputDialog(
                          context: context,
                          title: 'Select Location',
                          onSubmit: (value, map) {
                            value = value.split(map['city'])[0];
                            addressLine1Controller.text =
                                value.substring(0, value.length - 2);
                            city = map['city'];
                            zipCodeController.text = map['postcode'];
                          });
                    },
                    icon: const Icon(Icons.location_on),
                  ),
                  IconButton(
                    onPressed: () {
                      showSingleTextFieldInputDialog(
                        context: context,
                        title: 'Set Address Line 1',
                        onSubmit: (value) {
                          addressLine1Controller.text = value;
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ),
            Divider(
                height: 2,
                thickness: 1,
                color:
                    ThemeServices().loadTheme() ? Colors.white : Colors.black),
            ListTile(
              title: Text(addressLine2Controller.text ?? 'Not set yet'),
              subtitle: const Text('AddressLine 2'),
              trailing: IconButton(
                onPressed: () {
                  showSingleTextFieldInputDialog(
                    context: context,
                    title: 'Set Address Line 2',
                    onSubmit: (value) {
                      addressLine2Controller.text = value;
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            Divider(
                height: 2,
                thickness: 1,
                color:
                    ThemeServices().loadTheme() ? Colors.white : Colors.black),
            ListTile(
              title: Text(userProvider.userModel!.addressModel?.zipcode ??
                  'Not set yet'),
              subtitle: const Text('Zip Code'),
              trailing: IconButton(
                onPressed: () {
                  showSingleTextFieldInputDialog(
                    context: context,
                    title: 'Set Zip Code',
                    onSubmit: (value) {
                      int.tryParse(value) != null
                          ? zipCodeController.text = value
                          : showMsg(context, 'Please Enter valid Code');
                    },
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),

            Divider(
                height: 2,
                thickness: 1,
                color:
                    ThemeServices().loadTheme() ? Colors.white : Colors.black),
            ListTile(
              title: Text(city ?? 'Not set yet'),
              subtitle: const Text('City'),
              trailing: IconButton(
                onPressed: () {
                  showCityInputDialog(
                      context: context,
                      title: 'Select City',
                      onSubmit: (value) {
                        if (value.split(',').length == 3) {
                          city = value.split(',')[2];
                        } else {
                          city = value;
                        }
                      });
                },
                icon: const Icon(Icons.edit),
              ),
            ),
            // DropdownButton<String>(
            //   value: city,
            //   isExpanded: true,
            //   hint: const Text('Select your city'),
            //   items: cities
            //       .map((city) => DropdownMenuItem<String>(
            //             value: city,
            //             child: Text(city),
            //           ))
            //       .toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       city = value;
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  Widget buildPaymentMethodSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Radio<String>(
              value: PaymentMethod.cod,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.cod),
            Radio<String>(
              value: PaymentMethod.online,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.online),
          ],
        ),
      ),
    );
  }

  Widget buildOrderButtonSection() {
    return ElevatedButton(
      onPressed: _saveOrder,
      child: const Text('PLACE ORDER'),
    );
  }

  void _saveOrder() {}

  void setAddressIfExists() {
    final userModel = userProvider.userModel;
    if (userModel != null) {
      if (userModel.addressModel != null) {
        final address = userModel.addressModel!;
        addressLine1Controller.text = address.addressLine1 ?? '';
        addressLine2Controller.text = address.addressLine2 ?? '';
        zipCodeController.text = address.zipcode ?? '';
        city = address.city ?? '';
      }
    }
  }
}

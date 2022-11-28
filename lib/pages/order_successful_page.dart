import 'package:flutter/material.dart';
// import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
// import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
// import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
// import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
// import 'package:flutter_sslcommerz/sslcommerz.dart';
// import 'package:fluttertoast/fluttertoast.dart';

enum SdkType { TESTBOX, LIVE }

class OrderSuccessfulPage extends StatefulWidget {
  static const String routeName = '/order_successful';
  const OrderSuccessfulPage({Key? key}) : super(key: key);

  @override
  State<OrderSuccessfulPage> createState() => _OrderSuccessfulPageState();
}

class _OrderSuccessfulPageState extends State<OrderSuccessfulPage> {
  var _key = GlobalKey<FormState>();
  dynamic formData = {};
  SdkType _radioSelected = SdkType.TESTBOX;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Icon(
              Icons.done,
              color: Colors.green,
              size: 150,
            ),
            Text('Your order has been placed.'),
            Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: "demotest",
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            hintText: "Store ID",
                          ),
                          validator: (value) {
                            if (value != null)
                              return "Please input store id";
                            else
                              return null;
                          },
                          onSaved: (value) {
                            formData['store_id'] = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: "qwerty",
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            hintText: "Store password",
                          ),
                          validator: (value) {
                            if (value != null)
                              return "Please input store password";
                            else
                              return null;
                          },
                          onSaved: (value) {
                            formData['store_password'] = value;
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: SdkType.TESTBOX,
                            groupValue: _radioSelected,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value as SdkType;
                              });
                            },
                          ),
                          Text("TEXTBOX"),
                          Radio(
                            value: SdkType.LIVE,
                            groupValue: _radioSelected,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                _radioSelected = value as SdkType;
                              });
                            },
                          ),
                          Text('LIVE'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            hintText: "Phone number",
                          ),
                          onSaved: (value) {
                            formData['phone'] = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: "10",
                          // keyboardType: TextInputType.number,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            hintText: "Payment amount",
                          ),
                          validator: (value) {
                            if (value != null)
                              return "Please input amount";
                            else
                              return null;
                          },
                          onSaved: (value) {
                            formData['amount'] = double.parse(value!);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            hintText: "Enter multi card",
                          ),
                          onSaved: (value) {
                            formData['multicard'] = value;
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: Text("Pay now"),
                        onPressed: () {
                          if (_key.currentState != null) {
                            _key.currentState?.save();
                            print(_radioSelected);
                            // sslCommerzGeneralCall();
                            // sslCommerzCustomizedCall();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> sslCommerzGeneralCall() async {
  //   Sslcommerz sslcommerz = Sslcommerz(
  //     initializer: SSLCommerzInitialization(
  //       //Use the ipn if you have valid one, or it will fail the transaction.
  //       ipn_url: "www.ipnurl.com",
  //       multi_card_name: formData['multicard'],
  //       currency: SSLCurrencyType.BDT,
  //       product_category: "Food",
  //       sdkType: _radioSelected == SdkType.TESTBOX
  //           ? SSLCSdkType.TESTBOX
  //           : SSLCSdkType.LIVE,
  //       store_id: formData['store_id'],
  //       store_passwd: formData['store_password'],
  //       total_amount: formData['amount'],
  //       tran_id: "1231123131212",
  //     ),
  //   );
  //
  //   try {
  //     SSLCTransactionInfoModel result = await sslcommerz.payNow();
  //
  //     print('HHHHH' + result.toString());
  //     if (result.status!.toLowerCase() == "failed") {
  //       Fluttertoast.showToast(
  //         msg: "Transaction is Failed....",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     } else if (result.status!.toLowerCase() == "closed") {
  //       Fluttertoast.showToast(
  //         msg: "SDK Closed by User",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //           msg:
  //               "Transaction is ${result.status} and Amount is ${result.amount}",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // Future<void> sslCommerzCustomizedCall() async {
  //   Sslcommerz sslcommerz = Sslcommerz(
  //     initializer: SSLCommerzInitialization(
  //       //Use the ipn if you have valid one, or it will fail the transaction.
  //       ipn_url: "www.ipnurl.com",
  //       multi_card_name: formData['multicard'],
  //       currency: SSLCurrencyType.BDT,
  //       product_category: "Food",
  //       sdkType: SSLCSdkType.LIVE,
  //       store_id: formData['store_id'],
  //       store_passwd: formData['store_password'],
  //       total_amount: formData['amount'],
  //       tran_id: "1231321321321312",
  //     ),
  //   );
  // }
}

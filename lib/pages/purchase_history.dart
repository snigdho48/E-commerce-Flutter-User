import 'package:ecom_user_07/providers/order_provider.dart';
import 'package:ecom_user_07/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurchaseHistory extends StatelessWidget {
  static const String routeName = '/purchase_history';

  const PurchaseHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Purchase History'),
        ),
        body: Consumer<OrderProvider>(
            builder: (context, provider, child) {
              final purchaselist = provider.purchaseList;
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: purchaselist.length,
                  itemBuilder: (BuildContext context, int index) {
                    final purchaseItem=purchaselist[index];
                    return InkWell(
                      onTap: (){
                      },
                      child: ListTile(
                        title: Text(purchaseItem.orderId),
                        subtitle:Text('Order date: ${purchaseItem.orderDate.day}/${purchaseItem.orderDate.month}/${purchaseItem.orderDate.year}') ,
                        trailing: Text('$currencySymbol ${purchaseItem.grandTotal.toString()}'),
                      ),
                    );
                  }
              );
            }
        ));
  }
}

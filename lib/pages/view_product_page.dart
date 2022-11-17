import 'package:ecom_user_07/providers/cart_provider.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/cart_bubble_view.dart';
import '../customwidgets/main_drawer.dart';
import '../customwidgets/product_grid_item_view.dart';
import '../models/category_model.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;
  final txtController = TextEditingController();
  String name='Product';
  String order='None';
  bool hasorder=false;

  @override
  void dispose() {
       txtController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<UserProvider>(context,listen: false).getUserInfo();
    Provider.of<CartProvider>(context,listen: false).getAllCartItemsByUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('All Product'),
        actions: const [
          CartBubbleView(),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       SizedBox(
                        width:MediaQuery.of(context).size.width*.57,
                        child: TextField(
                          controller: txtController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter $name',

                          ),

                          onChanged: (value){
                            provider.filter(txtController.text,name,hasorder: hasorder);
                          },
                        ),
                      ),
                      const SizedBox(width: 15,),
                      SizedBox(
                        width:MediaQuery.of(context).size.width*.18,
                        child: DropdownButtonFormField<String>(
                          // style: const TextStyle(fontSize: 15,),
                          isExpanded: true,
                          hint: const Text('Select Category'),
                          value: name,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          items: List.generate(
                              choice.length,
                                  (index) => DropdownMenuItem(
                                         value: choice[index],
                                         child: Text(choice[index])
                                  )
                          ),

                          onChanged: (value) {
                            name=value!;
                            if(name== 'All') {
                              provider.getAllProducts();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width:MediaQuery.of(context).size.width*.17,
                        child: DropdownButtonFormField<String>(
                          // style: Theme.of(context).textTheme.displaySmall,
                          isExpanded: true,
                          hint: const Text('Select Order'),
                          value: order,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an order ';
                            }
                            return null;
                          },
                          items: List.generate(
                              orderlist.length,
                                  (index) => DropdownMenuItem(
                                  value: orderlist[index],
                                  child: Text(orderlist[index])
                              )
                          ),
                          onChanged: (value) {
                            setState(() {
                              order = value!;
                              provider.shorted(order);
                            });
                            if(order== 'None') {
                              provider.getAllProducts();                           }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.65),
                itemCount: ProductProvider.productList.length,
                itemBuilder: (context, index) {
                  final product = ProductProvider.productList[index];
                  return ProductGridItemView(
                    productModel: product,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

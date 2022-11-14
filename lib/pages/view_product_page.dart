import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/pages/product_details_page.dart';
import 'package:ecom_user_07/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/main_drawer.dart';
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

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('All Product'),
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
                      SizedBox(width: 15,),
                      SizedBox(
                        width:MediaQuery.of(context).size.width*.18,
                        child: DropdownButtonFormField<String>(
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
                      SizedBox(width: 15,),
                      SizedBox(
                        width:MediaQuery.of(context).size.width*.16,
                        child: DropdownButtonFormField<String>(
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
              child: ListView.builder(
                itemCount: provider.productList.length,
                itemBuilder: (context, index) {
                  final product = provider.productList[index];
                  return ListTile(
                    onTap: () => Navigator.pushNamed(
                        context, ProductDetailsPage.routeName,
                        arguments: product),
                    leading: CachedNetworkImage(
                      width: 50,
                      imageUrl: product.thumbnailImageModel.imageDownloadUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text(product.productName),
                    subtitle: Text(product.category.categoryName),
                    trailing: Text('Stock: ${product.stock}'),
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

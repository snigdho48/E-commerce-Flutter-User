import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/cart_bubble_view.dart';
import '../customwidgets/main_drawer.dart';
import '../customwidgets/product_grid_item_view.dart';
import '../models/category_model.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';

class ViewFavoriteProductPage extends StatefulWidget {
  static const String routeName = '/favouriteproduct';
  const ViewFavoriteProductPage({Key? key}) : super(key: key);

  @override
  State<ViewFavoriteProductPage> createState() => _ViewFavoriteProductPageState();
}

class _ViewFavoriteProductPageState extends State<ViewFavoriteProductPage> {
  CategoryModel? categoryModel;
  String name='Product';
  String order='None';
  bool hasorder=false;
  late final ProductProvider productProvider;

@override
  void didChangeDependencies() {
    productProvider=Provider.of<ProductProvider>(context,listen: false);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Favorite Product'),
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
                      const SizedBox(width: 15,),
                      SizedBox(
                        width:MediaQuery.of(context).size.width*.4,
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
                        width:MediaQuery.of(context).size.width*.4,
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
                itemCount: productProvider.favouriteProductList.length,
                itemBuilder: (context, index) {
                  final product = productProvider.favouriteProductList[index];
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

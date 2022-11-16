import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/models/cart_model.dart';
import 'package:ecom_user_07/providers/cart_provider.dart';
import 'package:ecom_user_07/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CartWidget extends StatefulWidget {
  final  CartModel cartModel;
  const CartWidget(this.cartModel, {Key? key}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
@override
  void didChangeDependencies() {
    Provider.of<CartProvider>(context,listen: false);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 5,
                child: CachedNetworkImage(
                  width: 80,
                  height: 100,
                  fit: BoxFit.fill,
                  imageUrl: widget.cartModel.productImageUrl,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(
                widget.cartModel.productName,
                style: Theme.of(context)
                    .textTheme
                    .headline6!,
              ),
              Text(
                'Unit Price: ${widget.cartModel.salePrice}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge                        ,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  const Text(
                    'Quantity: ',
                  ),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          Provider.of<CartProvider>(context,listen: false).updateCart(widget.cartModel, false);

                        });
                      },
                      icon: const Icon(Icons.remove,size: 15)),
                  const SizedBox(
                      width: 10),
                  Text(
                    '${widget.cartModel.quantity}',
                    ),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          Provider.of<CartProvider>(context,listen: false).updateCart(widget.cartModel, true);
                        });

                      },
                      icon: const Icon(Icons.add,size: 15)),
                ],
              ),

            ],
          ),

        ],
      ),
    );
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_user_07/models/cart_model.dart';
import 'package:ecom_user_07/providers/cart_provider.dart';
import 'package:flutter/material.dart';


class CartWidget extends StatefulWidget {
  final CartModel cartModel;
  final CartProvider provider;
  const CartWidget(
      {Key? key, required this.cartModel, required this.provider})
      : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
  }

class _CartWidgetState extends State<CartWidget> {
  @override

  Widget build(BuildContext context) {
    widget.provider.getProductInfoUpdate(widget.cartModel);
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
                          if(widget.cartModel.quantity>1){
                            widget.provider.updateCart(widget.cartModel, false);
                            widget.provider.getTotalPrice();
                          }
                        });

                          // widget.cartModel.quantity+=1;

                      },
                      icon: const Icon(Icons.remove_circle,size: 30)),
                  const SizedBox(
                      width: 10),
                  Text(
                    '${widget.cartModel.quantity}',
                    ),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          widget.provider.updateCart(widget.cartModel, true);
                          widget.provider.getTotalPrice();
                        });
                          // widget.cartModel.quantity+=1;
                      },
                      icon: const Icon(Icons.add_circle,size: 30)),
                ],
              ),

            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: (){
                        widget.provider.removeFromCart(widget.cartModel.productId);
                    },
                    icon: Icon(Icons.delete),),
                ),

              Text('${widget.provider.priceWithQuantity(widget.cartModel)}'),
              ],
            ),
          )

        ],
      ),
    );
  }
}



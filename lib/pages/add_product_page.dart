import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/category_model.dart';
import '../models/date_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../providers/product_provider.dart';
import '../utils/helper_functions.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/addproduct';

  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late ProductProvider _productProvider;
  final _nameController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? thumbnail;
  CategoryModel? categoryModel;
  DateTime? purchaseDate;
  ImageSource _imageSource = ImageSource.gallery;
  late StreamSubscription<ConnectivityResult> subscription;
  bool _isConnected = true;
  @override
  void initState() {
    isConnectedToInternet().then((value) {
      setState(() {
        _isConnected = value;
      });
    });
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            onPressed: _isConnected ? _saveProduct : null,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if(!_isConnected) const ListTile(
              tileColor: Colors.black,
              title: Text('No internet connection', style: TextStyle(color: Colors.white),),
            ),
            Consumer<ProductProvider>(
              builder: (context, provider, child) =>
                  DropdownButtonFormField<CategoryModel>(
                isExpanded: true,
                hint: const Text('Select Category'),
                value: categoryModel,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                items: provider.categoryList
                    .map((catModel) => DropdownMenuItem(
                          value: catModel,
                          child: Text(catModel.categoryName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoryModel = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Product Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                maxLines: 2,
                controller: _shortDescriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Short Description(optional)',
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                maxLines: 3,
                controller: _longDescriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Long Description(optional)',
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _purchasePriceController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Purchase Price',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) <= 0) {
                    return 'Price should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _salePriceController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Sale Price',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) <= 0) {
                    return 'Price should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _quantityController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Quantity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) <= 0) {
                    return 'Quantity should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _discountController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Discount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) < 0) {
                    return 'Discount should not be a negative value';
                  }
                  return null;
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Select Purchase Date'),
                    ),
                    Text(purchaseDate == null
                        ? 'No date chosen'
                        : getFormattedDate(purchaseDate!)),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: thumbnail == null ? const Icon(Icons.photo, size: 100,) :
                      Image.file(File(thumbnail!), width: 100, height: 100, fit: BoxFit.cover,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _imageSource = ImageSource.camera;
                            _getImage();
                          },
                          icon: const Icon(Icons.camera),
                          label: const Text('Open Camera'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _imageSource = ImageSource.gallery;
                            _getImage();
                          },
                          icon: const Icon(Icons.photo_album),
                          label: const Text('Open Gallery'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _discountController.dispose();
    _salePriceController.dispose();
    subscription.cancel();
    super.dispose();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if(date != null) {
      setState(() {
        purchaseDate = date;
      });
    }
  }

  void _getImage() async {
    final pickedImage = await ImagePicker().pickImage(source: _imageSource, imageQuality: 70,);
    if(pickedImage != null) {
      setState(() {
        print('IMAGE NAME: ${pickedImage.name}');
        thumbnail = pickedImage.path;
      });
    }
  }

  void _saveProduct() async {
    if(thumbnail == null) {
      showMsg(context, 'Please select a product image');
      return;
    }

    if(purchaseDate == null) {
      showMsg(context, 'Please select a purchase date');
      return;
    }

    if(_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      try {
        final imageModel = await _productProvider.uploadImage(thumbnail!);
        final productModel = ProductModel(
            productName: _nameController.text,
            shortDescription: _shortDescriptionController.text.isEmpty ? null : _shortDescriptionController.text,
            longDescription: _longDescriptionController.text.isEmpty ? null : _longDescriptionController.text,
            salePrice: num.parse(_salePriceController.text),
            productDiscount: num.parse(_discountController.text),
            stock: num.parse(_quantityController.text),
            category: categoryModel!,
            additionalImageModels: ['','',''],
            thumbnailImageModel: imageModel,
        );
        final purchaseModel = PurchaseModel(
          purchasePrice: num.parse(_purchasePriceController.text),
          purchaseQuantity: num.parse(_quantityController.text),
          dateModel: DateModel(
            timestamp: Timestamp.fromDate(purchaseDate!),
            day: purchaseDate!.day,
            month: purchaseDate!.month,
            year: purchaseDate!.year,
          ),
        );
        await _productProvider.addNewProduct(productModel, purchaseModel);
        EasyLoading.dismiss();
        if(mounted) {
          showMsg(context, 'Saved');
        }
        _resetFields();

      } catch(error) {
        EasyLoading.dismiss();
        showMsg(context, 'Could not save. Please check your connection');
        throw error;
      }


    }
  }

  void _resetFields() {
    setState(() {
      _nameController.clear();
      _shortDescriptionController.clear();
      _longDescriptionController.clear();
      _discountController.clear();
      _quantityController.clear();
      _salePriceController.clear();
      _purchasePriceController.clear();
      categoryModel = null;
      purchaseDate = null;
      thumbnail = null;
    });
  }
}

import 'dart:io';
import 'package:ecom_user_07/models/cart_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/comment_model.dart';
import '../models/image_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  static List<ProductModel> productList = [];
  List<ProductModel> filterproductList = [];
  List<PurchaseModel> purchaseList = [];
  List <String> list1=[];
  List <num> list2=[];
  String Order='None';

  Future<void> addCategory(String category) {
    final categoryModel = CategoryModel(categoryName: category);
    return DbHelper.addCategory(categoryModel);
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllPurchases() {
    DbHelper.getAllPurchases().listen((snapshot) {
      purchaseList = List.generate(snapshot.docs.length,
          (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String categoryName) {
    DbHelper.getAllProductsByCategory(categoryName).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  Future<void> addRating(
      String productId, double rating, UserModel userModel) async {
    final ratingModel = RatingModel(
      ratingId: AuthService.currentUser!.uid,
      userModel: userModel,
      productId: productId,
      rating: rating,
    );
    await DbHelper.addRating(ratingModel);
    final snapshot = await DbHelper.getRatingsByProduct(productId);
    final ratingModelList = List.generate(snapshot.docs.length,
            (index) => RatingModel.fromMap(snapshot.docs[index].data()));
    double totalRating = 0.0;
    for (var model in ratingModelList) {
      totalRating += model.rating;
    }
    final avgRating = totalRating / ratingModelList.length;
    return updateProductField(
        ratingModel.productId, productFieldAvgRating, avgRating);
  }

  Future<void> updateProductField(String proId, String field, dynamic value) {
    return DbHelper.updateProductField(proId, {field: value});
  }
  productFilterByName(String search, bool? hasorder,) {
    if(search.isNotEmpty){
      filterproductList=productList;
      productList=[];
      filterproductList.forEach((element) {
        if(element.category.categoryName.toLowerCase().contains(search)){
          productList.add(element);
        }
        });
    }else{
      getAllProducts();
    }
    hasorder??shorted(Order);

    notifyListeners();
  }

  productFilterByCategory(String search, bool? hasorder) {
    if(search.isNotEmpty){
      filterproductList=productList;
      productList=[];
      filterproductList.forEach((element) {
        if(element.category.categoryName.toLowerCase().contains(search)){
          productList.add(element);
        }
      });
    }else{
      getAllProducts();
    }
    hasorder??shorted(Order);

    notifyListeners();
  }

  void filter(String search,String name,{bool? hasorder}){
    if(name=='Product'){productFilterByName(search,hasorder);}
    else if(name=='Category'){productFilterByCategory(search,hasorder);}


  }
  void sortlisByName(List list){

    productList=[];
    list.forEach((key) {
      filterproductList.forEach((product) {
        if(product.productName.isCaseInsensitiveContains(key) ){
          productList.add(product); }
      });
    });
    productList.forEach((element) { print(element.productName);});

  }

  void sortlisByPrice(List list){

    productList=[];
    list.forEach((key) {
      filterproductList.forEach((product) {
        if(product.salePrice.compareTo(key)==0 ){
          productList.add(product);
        }
      });
    });
    productList.forEach((element) { print(element.productName);});

  }
  void shorted(String order){
    if(productList.isEmpty){
      productList=filterproductList;
    }
    if(productList.isNotEmpty){
      filterproductList=productList;
    }
    list1=List.generate(productList.length, (index) => productList[index].productName);
    list2=List.generate(productList.length, (index) => productList[index].salePrice);
    Order=order;
    if(order=='Ascending'){
      list1.sort((a, b) => a.compareTo(b));
      sortlisByName(list1);

    }else if(order=='Descending')
    {
      list1.sort((b, a) => a.compareTo(b));
      sortlisByName(list1);
    }else if(order=='Price Ascending')
    {
      list2.sort((a, b) => a.compareTo(b));
      sortlisByPrice(list2);
    }else if(order=='Price Descending')
    {
      list2.sort((b, a) => a.compareTo(b));
      sortlisByPrice(list2);
    }
  }

  List<PurchaseModel> getPurchasesByProductId(String productId) {
    return purchaseList
        .where((element) => element.productId == productId)
        .toList();
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList.sort((model1, model2) =>
          model1.categoryName.compareTo(model2.categoryName));
      notifyListeners();
    });
  }

  List<CategoryModel> getCategoriesForFiltering() {
    return <CategoryModel>[
      CategoryModel(categoryName: 'All'),
      ...categoryList,
    ];
  }

  Future<ImageModel> uploadImage(String path) async {
    final imageName = 'pro_${DateTime.now().millisecondsSinceEpoch}';
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('$firebaseStorageProductImageDir/$imageName');
    final uploadTask = imageRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return ImageModel(
      title: imageName,
      imageDownloadUrl: downloadUrl,
    );
  }

  Future<void> deleteImage(String url) {
    return FirebaseStorage.instance.refFromURL(url).delete();
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DbHelper.addNewProduct(productModel, purchaseModel);
  }

  Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  double priceAfterDiscount(num price, num discount) {
    final discountAmount = (price * discount) / 100;
    return price - discountAmount;
  }
  // comment
  Future<List<CommentModel>> getCommentsByProduct(String proId) async {
    final snapshot = await DbHelper.getCommentsByProduct(proId);
    final commentList = List.generate(snapshot.docs.length,
            (index) => CommentModel.fromMap(snapshot.docs[index].data()));
    return commentList;
  }


  Future<void> addComment(String proId, String comment, UserModel userModel) {
    final commentModel = CommentModel(
      userModel: userModel,
      productId: proId,
      comment: comment,
      date: getFormattedDate(DateTime.now(), pattern: 'dd/MM/yyyy hh:mm:s a'),
    );
    return DbHelper.addComment(commentModel);
  }





}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_07/auth/auth_service.dart';
import 'package:ecom_user_07/models/user_model.dart';

import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/comment_model.dart';
import '../models/favourite_model.dart';
import '../models/order_constant_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../models/rating_model.dart';

class DbHelper {
  static const String collectionAdmin = 'Admins';
  static final _db = FirebaseFirestore.instance;

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    final doc = _db.collection(collectionUser).doc(userModel.userId);
    return doc.set(userModel.toMap());
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final catDoc = _db.collection(collectionCategory).doc();
    categoryModel.categoryId = catDoc.id;
    return catDoc.set(categoryModel.toMap());
  }

  static Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    final wb = _db.batch();
    final productDoc = _db.collection(collectionProduct).doc();
    final purchaseDoc = _db.collection(collectionPurchase).doc();
    productModel.productId = productDoc.id;
    purchaseModel.productId = productDoc.id;
    purchaseModel.purchaseId = purchaseDoc.id;
    wb.set(productDoc, productModel.toMap());
    wb.set(purchaseDoc, purchaseModel.toMap());
    final updatedCount =
        purchaseModel.purchaseQuantity + productModel.category.productCount;
    final catDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    wb.update(catDoc, {categoryFieldProductCount: updatedCount});
    return wb.commit();
  }
  static Future<void> addRating(RatingModel ratingModel) {
    final ratingDoc = _db
        .collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userModel.userId);
    return ratingDoc.set(ratingModel.toMap());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRatingsByProduct(
      String proId) =>
      _db.collection(collectionProduct).doc(proId).collection(collectionRating).get();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionUtils).doc(documentOrderConstants).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchases() =>
      _db.collection(collectionPurchase).snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllPurchaseByProductId(
          String productId) =>
      _db
          .collection(collectionPurchase)
          .where(purchaseFieldProductId, isEqualTo: productId)
          .get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          String categoryName) =>
      _db
          .collection(collectionProduct)
          .where('$productFieldCategory.$categoryFieldName',
              isEqualTo: categoryName)
          .snapshots();

  static Future<void> updateUserProfileField(
      String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }

  static Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) async {
    final wb = _db.batch();
    final doc = _db.collection(collectionPurchase).doc();
    purchaseModel.purchaseId = doc.id;
    wb.set(doc, purchaseModel.toMap());
    final productDoc =
        _db.collection(collectionProduct).doc(productModel.productId);
    wb.update(productDoc, {
      productFieldStock: (productModel.stock + purchaseModel.purchaseQuantity)
    });
    final snapshot = await _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId)
        .get();
    final previousCount = snapshot.data()?[categoryFieldProductCount] ?? 0;
    final catDoc = _db
        .collection(collectionCategory)
        .doc(productModel.category.categoryId);
    wb.update(catDoc, {
      categoryFieldProductCount:
          (purchaseModel.purchaseQuantity + previousCount)
    });
    return wb.commit();
  }

  static Future<void> updateOrderConstants(OrderConstantModel model) {
    return _db
        .collection(collectionUtils)
        .doc(documentOrderConstants)
        .update(model.toMap());
  }
  static Future<void> updateProductField(
      String proId, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(proId).update(map);
  }
  //comment
  static Future<QuerySnapshot<Map<String, dynamic>>> getCommentsByProduct(
      String proId) =>
      _db
          .collection(collectionProduct)
          .doc(proId)
          .collection(collectionComment)
          .where(commentFieldApproved, isEqualTo: true)
          .get();


  static Future<void> addComment(CommentModel commentModel) {
    final doc = _db
        .collection(collectionProduct)
        .doc(commentModel.productId)
        .collection(collectionComment)
        .doc();
    commentModel.commentId = doc.id;
    return doc.set(commentModel.toMap());
  }

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartItemsByUser(
      String uid) {
    final info = _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .snapshots();
    print('cart ${info.length}');
    return info;
  }


  static Future<void> removeFromCart(String uid, String pid) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(pid)
        .delete();
  }
  static Future<void> updateCartQuantity(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> clearCart(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    for (final cartModel in cartList) {
      final doc = _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .doc(cartModel.productId);
      wb.delete(doc);
    }
    return wb.commit();
  }
  //favorite

   static Stream<QuerySnapshot<Map<String, dynamic>>> getFavouriteByUser(
      String uid) {
    final info = _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionFavourite)
        .snapshots();
    return info;
  }

  static Future<void> addfavourite(FavouriteModel favouriteModel) {
    return _db
        .collection(collectionUser)
        .doc(AuthService.currentUser!.uid)
        .collection(collectionFavourite)
        .doc(favouriteModel.productId)
        .set(favouriteModel.toMap());
  }

  static Future<void> removefavourite(String uid, String pid) {
    return _db
        .collection(collectionUser)
        .doc(uid)
        .collection(collectionFavourite)
        .doc(pid)
        .delete();
  }

}

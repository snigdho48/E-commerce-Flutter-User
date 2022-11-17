
const String collectionFavourite = 'Favourite';

const String favouriteFieldId = 'favouriteId';
const String favouriteFieldProductId = 'productId';
const String favouriteFieldFavourite = 'isFavourite';

class FavouriteModel {
  String favouriteId;
  String productId;
  bool favourite;

  FavouriteModel(
      {required this.favouriteId,
        required this.productId,
        this.favourite =false
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      favouriteFieldId: favouriteId,
      favouriteFieldProductId: productId,
      favouriteFieldFavourite: favourite,
    };
  }

  factory FavouriteModel.fromMap(Map<String, dynamic> map) => FavouriteModel(
    favouriteId: map[favouriteFieldId],
    productId: map[favouriteFieldProductId],
    favourite: map[favouriteFieldFavourite],
  );
}

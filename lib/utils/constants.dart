const String firebaseStorageProductImageDir = 'ProductImages';
const String currencySymbol = '৳';
const List<String> choice=['Product','Category'];
const List<String> orderlist=['None','Ascending','Descending','Price Ascending','Price Descending'];
const cities = [
  'Dhaka',
  'Chittagong',
  'Rajshahi',
  'Khulna',
  'Barishal',
  'Sylhet',
  'Comilla',
  'Noakhali',
  'Faridpur',
  'Rangpur',
  'Gopalgonj'
];

abstract class PaymentStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  static const String returned = 'Returned';
}

abstract class PaymentMethod {
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

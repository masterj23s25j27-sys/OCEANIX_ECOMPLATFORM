import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}

class Order {
  final String id;
  final String date;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String pincode;
  final String country;
  final List<CartItem> items;
  final double totalAmount;
  String status; // Pending, Processing, Shipped, Delivered, Cancelled
  String paymentStatus; // Pending, Completed, Failed
  String notes;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.date,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.pincode,
    required this.country,
    required this.items,
    required this.totalAmount,
    this.status = 'Pending',
    this.paymentStatus = 'Pending',
    this.notes = '',
    required this.createdAt,
  });
}

class CartState with ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];
  String _couponCode = '';
  double _couponDiscountPercent = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.total);
  }

  double get discountAmount {
    return subtotal * _couponDiscountPercent;
  }

  double get tax {
    // 18% GST
    return (subtotal - discountAmount) * 0.18;
  }

  double get shipping {
    if (subtotal == 0 || subtotal - discountAmount >= 5000.0) {
      return 0.0;
    }
    return 150.0;
  }

  double get totalAmount {
    return (subtotal - discountAmount) + tax + shipping;
  }

  String get couponCode => _couponCode;
  double get couponDiscountPercent => _couponDiscountPercent;

  void addItem(Product product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void addItemWithQuantity(Product product, int qty) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += qty;
    } else {
      _items.add(CartItem(product: product, quantity: qty));
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final sanitizedCode = code.trim().toUpperCase();
    if (sanitizedCode == 'OCEANIX20') {
      _couponCode = sanitizedCode;
      _couponDiscountPercent = 0.20; // 20% Off
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _couponCode = '';
    _couponDiscountPercent = 0.0;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _couponCode = '';
    _couponDiscountPercent = 0.0;
    notifyListeners();
  }

  // Order Management
  void placeOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].status = status;
      notifyListeners();
    }
  }

  void updateOrderPaymentStatus(String orderId, String paymentStatus) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].paymentStatus = paymentStatus;
      notifyListeners();
    }
  }

  void updateOrderNotes(String orderId, String notes) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].notes = notes;
      notifyListeners();
    }
  }
}

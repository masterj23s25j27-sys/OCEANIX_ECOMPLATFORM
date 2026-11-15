import 'package:flutter/foundation.dart' hide Category;
import '../models/product.dart';

class CatalogState with ChangeNotifier {
  final List<Product> _products = List.from(mockProducts);
  final List<Category> _categories = List.from(mockCategories);

  List<Product> get products => List.unmodifiable(_products);
  
  List<Product> get activeProducts => 
      _products.where((product) => product.isActive).toList();

  List<Category> get categories => List.unmodifiable(_categories);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void editProduct(Product updatedProduct) {
    final idx = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (idx >= 0) {
      _products[idx] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void adjustStock(String id, int quantity) {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      final p = _products[idx];
      _products[idx] = Product(
        id: p.id,
        name: p.name,
        categoryId: p.categoryId,
        shortDescription: p.shortDescription,
        description: p.description,
        highlights: p.highlights,
        price: p.price,
        mrp: p.mrp,
        discountPercent: p.discountPercent,
        rating: p.rating,
        reviewCount: p.reviewCount,
        imageUrl: p.imageUrl,
        isActive: p.isActive,
        isFeatured: p.isFeatured,
        isNewArrival: p.isNewArrival,
        isTrending: p.isTrending,
        isBestSeller: p.isBestSeller,
        stock: (p.stock + quantity).clamp(0, 9999),
      );
      notifyListeners();
    }
  }

  void toggleActive(String id) {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx >= 0) {
      final p = _products[idx];
      _products[idx] = Product(
        id: p.id,
        name: p.name,
        categoryId: p.categoryId,
        shortDescription: p.shortDescription,
        description: p.description,
        highlights: p.highlights,
        price: p.price,
        mrp: p.mrp,
        discountPercent: p.discountPercent,
        rating: p.rating,
        reviewCount: p.reviewCount,
        imageUrl: p.imageUrl,
        isActive: !p.isActive,
        isFeatured: p.isFeatured,
        isNewArrival: p.isNewArrival,
        isTrending: p.isTrending,
        isBestSeller: p.isBestSeller,
        stock: p.stock,
      );
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';

class SellerProduct {
  final String id;
  final String name;
  final double price;
  int stock;
  final String imageUrl;

  SellerProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });
}

class SellerPanelScreen extends StatefulWidget {
  const SellerPanelScreen({super.key});

  @override
  State<SellerPanelScreen> createState() => _SellerPanelScreenState();
}

class _SellerPanelScreenState extends State<SellerPanelScreen> {
  final List<SellerProduct> _sellerProducts = [
    SellerProduct(
      id: 'sp_1',
      name: 'Professional Stainless Steel Coconut Opener Tool',
      price: 299.99,
      stock: 45,
      imageUrl: 'assets/WhatsApp Image 2026-06-05 at 16.03.18.jpeg',
    ),
    SellerProduct(
      id: 'sp_2',
      name: '3 Compartment Stainless Steel Lunch Box Set',
      price: 599.99,
      stock: 120,
      imageUrl: 'assets/24141241.jpeg',
    ),
  ];

  void _adjustStock(SellerProduct product, int delta) {
    setState(() {
      product.stock = (product.stock + delta).clamp(0, 9999);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Seller Dashboard',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Sales', '₹1,24,980', const Color(0xFFEFF6FF), const Color(0xFF2563EB))),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Open Orders', '5 Orders', const Color(0xFFECFDF5), const Color(0xFF10B981))),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'My Products & Stock',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 12),

            // Product List
            ..._sellerProducts.map((product) => _buildSellerProductCard(product)),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerProductCard(SellerProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                product.imageUrl,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 60,
                  width: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.store, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text('Price: ₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text('Stock: ${product.stock} units', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: product.stock < 50 ? Colors.amber[700] : Colors.green)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Stock adjuster
            Row(
              children: [
                IconButton(
                  onPressed: () => _adjustStock(product, -5),
                  icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF64748B), size: 20),
                ),
                IconButton(
                  onPressed: () => _adjustStock(product, 5),
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2563EB), size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

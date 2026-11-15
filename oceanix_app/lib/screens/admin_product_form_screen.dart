import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/catalog_state.dart';

class AdminProductFormScreen extends StatefulWidget {
  final CatalogState catalogState;
  final Product? product; // Null if adding, otherwise editing

  const AdminProductFormScreen({
    super.key,
    required this.catalogState,
    this.product,
  });

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _mrpController;
  late final TextEditingController _stockController;
  late final TextEditingController _shortDescController;
  late final TextEditingController _descController;
  late final TextEditingController _highlightsController;
  late String _selectedCategoryId;
  late String _imageUrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _mrpController = TextEditingController(text: p?.mrp.toString() ?? '');
    _stockController = TextEditingController(text: p?.stock.toString() ?? '');
    _shortDescController = TextEditingController(text: p?.shortDescription ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _highlightsController = TextEditingController(text: p?.highlights.join('\n') ?? '');
    _selectedCategoryId = p?.categoryId ?? mockCategories[0].id;
    _imageUrl = p?.imageUrl ?? 'assets/logo.jpeg';
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _stockController.dispose();
    _shortDescController.dispose();
    _descController.dispose();
    _highlightsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final mrp = double.tryParse(_mrpController.text.trim()) ?? price;
      final stock = int.parse(_stockController.text.trim());
      final shortDesc = _shortDescController.text.trim();
      final desc = _descController.text.trim();
      final highlights = _highlightsController.text.split('\n').where((h) => h.trim().isNotEmpty).toList();

      if (widget.product == null) {
        // Add Mode
        final id = 'prod_${DateTime.now().millisecondsSinceEpoch}';
        final newProduct = Product(
          id: id,
          name: name,
          categoryId: _selectedCategoryId,
          shortDescription: shortDesc,
          description: desc,
          highlights: highlights.isEmpty ? ['Premium Product'] : highlights,
          price: price,
          mrp: mrp,
          discountPercent: mrp > price ? (((mrp - price) / mrp) * 100).round() : 0,
          rating: 4.5,
          reviewCount: 1,
          imageUrl: _imageUrl,
          isActive: _isActive,
          stock: stock,
          isFeatured: true,
        );
        widget.catalogState.addProduct(newProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
      } else {
        // Edit Mode
        final existing = widget.product!;
        final updatedProduct = Product(
          id: existing.id,
          name: name,
          categoryId: _selectedCategoryId,
          shortDescription: shortDesc,
          description: desc,
          highlights: highlights.isEmpty ? ['Premium Product'] : highlights,
          price: price,
          mrp: mrp,
          discountPercent: mrp > price ? (((mrp - price) / mrp) * 100).round() : 0,
          rating: existing.rating,
          reviewCount: existing.reviewCount,
          imageUrl: _imageUrl,
          isActive: _isActive,
          stock: stock,
          isFeatured: existing.isFeatured,
          isNewArrival: existing.isNewArrival,
          isTrending: existing.isTrending,
          isBestSeller: existing.isBestSeller,
        );
        widget.catalogState.editProduct(updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField('Product Name', _nameController, (val) => val == null || val.isEmpty ? 'Required' : null),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Price (₹)', _priceController, (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null, keyboardType: TextInputType.number),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('MRP (₹)', _mrpController, (val) => val == null || double.tryParse(val) == null ? 'Invalid' : null, keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Stock Level', _stockController, (val) => val == null || int.tryParse(val) == null ? 'Invalid' : null, keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField('Short Description', _shortDescController, (val) => null),
                    const SizedBox(height: 16),
                    _buildTextField('Description Details', _descController, (val) => val == null || val.isEmpty ? 'Required' : null, maxLines: 4),
                    const SizedBox(height: 16),
                    _buildTextField('Highlights (One per line)', _highlightsController, (val) => null, maxLines: 3),
                    const SizedBox(height: 16),
                    _buildActiveSwitch(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isEdit ? 'SAVE CHANGES' : 'CREATE PRODUCT',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategoryId,
        decoration: const InputDecoration(
          labelText: 'Category',
          border: InputBorder.none,
        ),
        items: mockCategories.map((cat) {
          return DropdownMenuItem<String>(
            value: cat.id,
            child: Text(cat.name, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() {
              _selectedCategoryId = val;
            });
          }
        },
      ),
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Active Status (Visible to Customers)',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
        ),
        Switch(
          value: _isActive,
          onChanged: (val) => setState(() => _isActive = val),
          activeColor: const Color(0xFF10B981),
        ),
      ],
    );
  }
}

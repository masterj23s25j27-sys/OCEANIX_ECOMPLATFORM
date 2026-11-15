import 'dart:math';
import 'package:flutter/material.dart';
import '../state/cart_state.dart';
import 'orders_history_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartState cartState;

  const CheckoutScreen({
    super.key,
    required this.cartState,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');

  String _selectedPaymentMethod = 'cod';
  bool _isProcessing = false;
  bool _orderSuccess = false;
  late final String _orderId;
  late Order _placedOrder;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _orderId = 'OX-2026-${random.nextInt(90000) + 10000}';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate payment delay
      await Future.delayed(const Duration(seconds: 2));

      // Capture date
      final now = DateTime.now();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';

      // Capture order object
      _placedOrder = Order(
        id: _orderId,
        date: dateStr,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        pincode: _pincodeController.text.trim(),
        country: _countryController.text.trim(),
        items: List.from(widget.cartState.items),
        totalAmount: widget.cartState.totalAmount,
        status: 'Pending',
        paymentStatus: _selectedPaymentMethod == 'cod' ? 'Pending' : 'Completed',
        createdAt: now,
      );

      // Save to global state list
      widget.cartState.placeOrder(_placedOrder);

      // Clear the shopping cart
      widget.cartState.clear();

      setState(() {
        _isProcessing = false;
        _orderSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_orderSuccess) {
      return _buildSuccessScreen();
    }

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
          'Checkout',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAddressForm(),

                  const SizedBox(height: 24),
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethods(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing payment...',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildPaymentStickyBar(),
    );
  }

  Widget _buildAddressForm() {
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
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField('First Name', _firstNameController, (val) => val == null || val.isEmpty ? 'Required' : null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField('Last Name', _lastNameController, (val) => val == null || val.isEmpty ? 'Required' : null),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('Email Address', _emailController, (val) => val == null || !val.contains('@') ? 'Invalid Email' : null, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _buildTextField('Phone Number', _phoneController, (val) => val == null || val.length < 10 ? 'Invalid Phone' : null, keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          _buildTextField('Street Address', _addressController, (val) => val == null || val.isEmpty ? 'Required' : null, maxLines: 2),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField('City', _cityController, (val) => val == null || val.isEmpty ? 'Required' : null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField('Pincode', _pincodeController, (val) => val == null || val.length != 6 ? 'Invalid PIN' : null, keyboardType: TextInputType.number),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField('Country', _countryController, (val) => val == null || val.isEmpty ? 'Required' : null),
        ],
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
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
        children: [
          RadioListTile<String>(
            value: 'cod',
            groupValue: _selectedPaymentMethod,
            onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            title: const Text('Cash on Delivery (COD)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: const Text('Pay with cash upon delivery', style: TextStyle(fontSize: 12, color: Colors.grey)),
            activeColor: const Color(0xFF2563EB),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          RadioListTile<String>(
            value: 'card',
            groupValue: _selectedPaymentMethod,
            onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
            title: const Text('Credit / Debit Card (Mock)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: const Text('Simulate bank card gateways', style: TextStyle(fontSize: 12, color: Colors.grey)),
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStickyBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              'PLACE ORDER (₹${widget.cartState.totalAmount.toStringAsFixed(2)})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 24),

              // Order Summary Card
              _buildReceiptCard(),
              const SizedBox(height: 16),

              // Next Steps Checklist Card
              _buildNextStepsCard(),
              const SizedBox(height: 28),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersHistoryScreen(cartState: widget.cartState)),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('View Orders', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Shop More', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard() {
    Widget summaryRow(String label, String value, {bool isBold = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: isBold ? const Color(0xFF0F172A) : const Color(0xFF64748B), fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
            Text(value, style: TextStyle(fontSize: 12, color: isBold ? const Color(0xFF2563EB) : const Color(0xFF0F172A), fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          summaryRow('Order Number', _placedOrder.id, isBold: true),
          summaryRow('Date', _placedOrder.date),
          summaryRow('Status', _placedOrder.status),
          summaryRow('Payment Status', _placedOrder.paymentStatus),
          const Divider(height: 20),
          const Text('Delivery Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
          const SizedBox(height: 6),
          Text('${_placedOrder.firstName} ${_placedOrder.lastName}', style: const TextStyle(fontSize: 12)),
          Text(_placedOrder.address, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text('${_placedOrder.city} - ${_placedOrder.pincode}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const Divider(height: 20),
          summaryRow('Grand Total', '₹${_placedOrder.totalAmount.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    Widget stepItem(String index, String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
              child: Text(index, style: const TextStyle(color: Color(0xFF2563EB), fontSize: 9, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Next Steps Guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          stepItem('1', 'Confirmation email will be sent'),
          stepItem('2', 'Processing within 1-2 business days'),
          stepItem('3', 'Tracking information upon shipment'),
          stepItem('4', 'Check status in order history'),
        ],
      ),
    );
  }
}

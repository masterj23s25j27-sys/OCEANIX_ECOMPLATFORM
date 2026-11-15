import 'package:flutter/material.dart';

class Address {
  final String id;
  final String title;
  final String name;
  final String details;
  final String contact;
  bool isDefault;

  Address({
    required this.id,
    required this.title,
    required this.name,
    required this.details,
    required this.contact,
    this.isDefault = false,
  });
}

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<Address> _addresses = [
    Address(
      id: 'addr_1',
      title: 'Home Address',
      name: 'Jayesh Kakkarot',
      details: 'Flat 402, Ocean Breeze Apartments, Hitech City, Hyderabad, 500081',
      contact: '+91 98765 43210',
      isDefault: true,
    ),
    Address(
      id: 'addr_2',
      title: 'Office Address',
      name: 'Jayesh Kakkarot',
      details: 'Building 14, Mindspace IT Park, Madhapur, Hyderabad, 500081',
      contact: '+91 98765 55432',
    ),
  ];

  void _addMockAddress() {
    setState(() {
      _addresses.add(
        Address(
          id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Secondary Address',
          name: 'Jayesh Kakkarot',
          details: 'Sector 5, Salt Lake, Kolkata, West Bengal, 700091',
          contact: '+91 98765 11223',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mock Address added successfully!')),
    );
  }

  void _removeAddress(String id) {
    setState(() {
      _addresses.removeWhere((addr) => addr.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address deleted.')),
    );
  }

  void _setDefault(String id) {
    setState(() {
      for (var addr in _addresses) {
        addr.isDefault = (addr.id == id);
      }
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
          'Saved Addresses',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: _addresses.isEmpty
          ? const Center(child: Text('No addresses found. Click + to add.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              address.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            if (address.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'DEFAULT',
                                  style: TextStyle(color: Color(0xFF2563EB), fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(address.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                        const SizedBox(height: 4),
                        Text(address.details, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4)),
                        const SizedBox(height: 6),
                        Text('Phone: ${address.contact}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!address.isDefault)
                              TextButton(
                                onPressed: () => _setDefault(address.id),
                                child: const Text('Set as Default', style: TextStyle(fontSize: 12)),
                              ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => _removeAddress(address.id),
                              icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFEF4444)),
                              label: const Text('Delete', style: TextStyle(fontSize: 12, color: Color(0xFFEF4444))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMockAddress,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

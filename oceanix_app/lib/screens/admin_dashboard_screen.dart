import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/cart_state.dart';
import '../state/catalog_state.dart';
import 'admin_inventory_screen.dart';
import 'admin_orders_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  final CartState cartState;

  const AdminDashboardScreen({
    super.key,
    required this.cartState,
  });

  @override
  Widget build(BuildContext context) {
    final catalogState = Provider.of<CatalogState>(context, listen: false);
    final orders = cartState.orders;

    // Calculate revenue
    final double revenueVal = orders.fold(0.0, (sum, o) => sum + o.totalAmount);
    final totalProducts = catalogState.products.length;

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
          'Admin Portal',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: cartState,
        builder: (context, child) {
          final orders = cartState.orders;
          final double dynamicRevenue = orders.fold(0.0, (sum, o) => sum + o.totalAmount);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Analytics grid
                Row(
                  children: [
                    Expanded(
                      child: _buildAdminStatCard(
                        'Total Revenue',
                        '₹${dynamicRevenue.toStringAsFixed(2)}',
                        const Color(0xFFEFF6FF),
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAdminStatCard(
                        'Total Orders',
                        '${orders.length} Orders',
                        const Color(0xFFECFDF5),
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAdminStatCard(
                        'Total Products',
                        '$totalProducts Items',
                        const Color(0xFFFFF7ED),
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAdminStatCard(
                        'Active Sellers',
                        '1 Seller (You)',
                        const Color(0xFFFEF2F2),
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const Text(
                  'Management Shortcuts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),

                _buildShortCutTile(
                  context,
                  Icons.inventory_2_outlined,
                  'Inventory Management',
                  'Adjust product stocks and pricing tables',
                  AdminInventoryScreen(catalogState: catalogState),
                ),
                const SizedBox(height: 12),
                _buildShortCutTile(
                  context,
                  Icons.shopping_bag_outlined,
                  'Order Logs & Dispatch',
                  'Update order delivery status tags',
                  AdminOrdersScreen(cartState: cartState),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminStatCard(String label, String value, Color bgColor, Color iconColor) {
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildShortCutTile(BuildContext context, IconData icon, String title, String subtitle, Widget screen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}

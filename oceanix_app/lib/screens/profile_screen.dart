import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart_state.dart';
import 'profile_edit_screen.dart';
import 'addresses_screen.dart';
import 'wishlist_screen.dart';
import 'subscriptions_screen.dart';
import 'seller_panel_screen.dart';
import 'admin_dashboard_screen.dart';
import 'orders_history_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function(Product, int) onAddToCart;
  final CartState cartState;

  const ProfileScreen({
    super.key,
    required this.onAddToCart,
    required this.cartState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Account',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Header
            _buildProfileHeader(),

            // Quick Stats
            _buildQuickStats(),

            const SizedBox(height: 12),

            // Seller Panel Banner
            _buildSellerPanelBanner(context),

            // Settings/Dashboard list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDashboardItem(
                    Icons.settings_outlined,
                    'Edit Profile',
                    'Change password and account details',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEditScreen())),
                  ),
                  _buildDashboardItem(
                    Icons.local_shipping_outlined,
                    'My Orders',
                    'Track and manage your orders',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersHistoryScreen(cartState: cartState))),
                  ),
                  _buildDashboardItem(
                    Icons.favorite_border_rounded,
                    'Wishlist',
                    'View your saved products',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistScreen(onAddToCart: onAddToCart))),
                  ),
                  _buildDashboardItem(
                    Icons.card_membership_outlined,
                    'Subscriptions',
                    'Manage recurring B2B delivery schedules',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionsScreen())),
                  ),
                  _buildDashboardItem(
                    Icons.map_outlined,
                    'Saved Addresses',
                    'Add and edit billing addresses',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressesScreen())),
                  ),
                  _buildDashboardItem(
                    Icons.admin_panel_settings_outlined,
                    'Admin Portal',
                    'Manage platform products, orders, and stats',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboardScreen(cartState: cartState))),
                  ),
                  _buildDashboardItem(
                    Icons.logout_rounded,
                    'Log Out',
                    'Sign out from this device',
                    isRed: true,
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
      child: Center(
        child: Column(
          children: [
            // Profile Initial Avatar
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'JK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Jayesh Kakkarot',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'jayesh@oceanix.com',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Gold Premium Member',
                    style: TextStyle(
                      color: Color(0xFFD97706),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: '${cartState.orders.length}', label: 'Orders'),
          const _StatItem(value: '4', label: 'Subscriptions'),
          const _StatItem(value: '8', label: 'Wishlist'),
        ],
      ),
    );
  }

  Widget _buildSellerPanelBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SellerPanelScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller Panel & Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Manage catalog, inventory, and B2B orders',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(IconData icon, String title, String subtitle, {bool isRed = false, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            color: isRed ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isRed ? const Color(0xFFEF4444) : const Color(0xFF475569), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isRed ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        onTap: onTap,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

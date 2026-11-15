import 'package:flutter/material.dart';

class Subscription {
  final String id;
  final String productName;
  final String interval;
  final double price;
  final String nextDelivery;
  String status;

  Subscription({
    required this.id,
    required this.productName,
    required this.interval,
    required this.price,
    required this.nextDelivery,
    required this.status,
  });
}

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final List<Subscription> _subscriptions = [
    Subscription(
      id: 'sub_1',
      productName: 'ErgoSoft Desk Office Chair (Bulk 5x)',
      interval: 'Monthly (Every 1st)',
      price: 62495.00,
      nextDelivery: '01 Aug 2026',
      status: 'Active',
    ),
    Subscription(
      id: 'sub_2',
      productName: 'Tactile Mech Keyboard K80 (Bulk 10x)',
      interval: 'Every 2 Months',
      price: 34990.00,
      nextDelivery: '15 Sep 2026',
      status: 'Active',
    ),
  ];

  void _toggleStatus(Subscription sub) {
    setState(() {
      sub.status = (sub.status == 'Active') ? 'Paused' : 'Active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Subscription status updated to: ${sub.status}')),
    );
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
          'My Subscriptions',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: _subscriptions.isEmpty
          ? const Center(child: Text('No active subscriptions.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _subscriptions.length,
              itemBuilder: (context, index) {
                final sub = _subscriptions[index];
                final isActive = sub.status == 'Active';

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
                            Expanded(
                              child: Text(
                                sub.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                sub.status,
                                style: TextStyle(
                                  color: isActive ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('FREQUENCY', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                                const SizedBox(height: 2),
                                Text(sub.interval, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TOTAL COST', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                                const SizedBox(height: 2),
                                Text('₹${sub.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('NEXT DELIVERY', style: TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
                                const SizedBox(height: 2),
                                Text(sub.nextDelivery, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _toggleStatus(sub),
                              child: Text(isActive ? 'Pause' : 'Activate', style: const TextStyle(fontSize: 12)),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Edit Schedule', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

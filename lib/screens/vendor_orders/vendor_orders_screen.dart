import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility/constants.dart';
import 'provider/vendor_order_provider.dart';

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorOrderProvider>().loadVendorOrders();
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.store, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Text(
                  "Vendor Orders",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Consumer<VendorOrderProvider>(
                  builder: (context, provider, _) => IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => provider.loadVendorOrders(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter Chips
            Consumer<VendorOrderProvider>(
              builder: (context, provider, _) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(context, 'All', 'all', provider),
                  _buildFilterChip(context, 'Pending', 'pending', provider),
                  _buildFilterChip(context, 'Accepted', 'accepted', provider),
                  _buildFilterChip(context, 'Rejected', 'rejected', provider),
                  _buildFilterChip(context, 'Packed', 'packed', provider),
                  _buildFilterChip(context, 'Processing', 'processing', provider),
                  _buildFilterChip(context, 'Delivered', 'delivered', provider),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Orders List
            Expanded(
              child: Consumer<VendorOrderProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.groups.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[600]),
                          const SizedBox(height: 12),
                          Text('No vendor orders found',
                              style: TextStyle(color: Colors.grey[400], fontSize: 16)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.groups.length,
                    itemBuilder: (context, index) {
                      return _buildVendorOrderCard(context, provider.groups[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String value, VendorOrderProvider provider) {
    final isSelected = provider.currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.orange.withOpacity(0.3),
      checkmarkColor: Colors.orange,
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: secondaryColor,
      side: BorderSide(color: isSelected ? Colors.orange : Colors.white24),
      onSelected: (_) => provider.filterByStatus(value),
    );
  }

  Widget _buildVendorOrderCard(BuildContext context, VendorOrderGroup group) {
    final order = group.order;
    final orderId = order.sId != null && order.sId!.length >= 6
        ? order.sId!.substring(order.sId!.length - 6).toUpperCase()
        : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              children: [
                Text('Order #$orderId',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const Spacer(),
                _buildStatusBadge(order.orderStatus ?? 'pending'),
              ],
            ),
            const SizedBox(height: 4),
            Text(_formatDate(order.orderDate),
                style: TextStyle(color: Colors.grey[500], fontSize: 12)),

            const Divider(color: Colors.white12, height: 20),

            // Vendor (Shopkeeper) Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.storefront, size: 18, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Vendor Details',
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, 'Name', group.vendorName),
                  _buildInfoRow(Icons.store, 'Shop', group.shopName),
                  _buildInfoRow(Icons.location_on, 'Address', group.shopAddress),
                  _buildInfoRow(Icons.phone, 'Phone', group.vendorPhone),
                  _buildInfoRow(Icons.email, 'Email', group.vendorEmail),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Customer Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Customer Details',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, 'Name', order.userID?.name ?? 'Unknown'),
                  _buildInfoRow(Icons.phone, 'Phone', order.shippingAddress?.phone ?? 'N/A'),
                  _buildInfoRow(Icons.location_on, 'Address',
                      '${order.shippingAddress?.village ?? ''}, ${order.shippingAddress?.panchayat ?? ''}, ${order.shippingAddress?.block ?? ''}'),
                ],
              ),
            ),

            const Divider(color: Colors.white12, height: 20),

            // Vendor Products Only
            const Text('Vendor Products:',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            ...group.vendorItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('x${item.quantity ?? 1}',
                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${item.productName ?? 'Unknown'} • ${item.unit ?? ''}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${((item.shopkeeperPrice ?? item.price ?? 0) * (item.quantity ?? 1)).toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      if ((item.quantity ?? 1) > 1)
                        Text(
                          '₹${(item.shopkeeperPrice ?? item.price ?? 0).toStringAsFixed(0)} each',
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                        ),
                    ],
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white38),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text('$label:', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending': color = Colors.orange; break;
      case 'accepted': color = Colors.teal; break;
      case 'rejected': color = Colors.red; break;
      case 'packed': color = Colors.indigo; break;
      case 'processing': color = Colors.blue; break;
      case 'delivered': color = Colors.green; break;
      case 'cancelled': color = Colors.red; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      final h = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final amPm = date.hour >= 12 ? 'PM' : 'AM';
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${h.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $amPm';
    } catch (e) {
      return dateStr.split('T').first;
    }
  }
}

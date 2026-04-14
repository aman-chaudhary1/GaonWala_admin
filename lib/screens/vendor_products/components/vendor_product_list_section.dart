import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/product.dart';
import '../../../../utility/constants.dart';
import '../provider/vendor_product_provider.dart';

class VendorProductListSection extends StatefulWidget {
  const VendorProductListSection({
    Key? key,
  }) : super(key: key);

  @override
  State<VendorProductListSection> createState() => _VendorProductListSectionState();
}

class _VendorProductListSectionState extends State<VendorProductListSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProductProvider>().getPendingProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pending Product Approvals",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<VendorProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.pendingProducts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("No pending products."),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 800),
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(label: Text("Product")),
                      DataColumn(label: Text("Shop")),
                      DataColumn(label: Text("Vendor Price")),
                      DataColumn(label: Text("Category")),
                      DataColumn(label: Text("Sub Category")),
                      DataColumn(label: Text("Actions")),
                    ],
                    rows: List.generate(
                      provider.pendingProducts.length,
                      (index) => productDataRow(context, provider.pendingProducts[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow productDataRow(BuildContext context, Product product) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            if (product.images != null && product.images!.isNotEmpty)
              Image.network(product.images![0].url!, height: 30, width: 30, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(product.name ?? 'No Name'),
            ),
          ],
        ),
      ),
      DataCell(Text(product.addedBy?.shopName ?? 'Unknown')),
      DataCell(Text("\u20B9${product.shopkeeperPrice?.toString() ?? '0'}")),
      DataCell(Text(product.proCategoryId?.name ?? 'N/A')),
      DataCell(Text(product.proSubCategoryId?.name ?? 'N/A')),
      DataCell(
        Row(
          children: [
            IconButton(
              onPressed: () {
                showProductDetailDialog(context, product);
              },
              icon: Icon(Icons.visibility, color: Colors.blue),
              tooltip: 'View Details',
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                showApproveDialog(context, product);
              },
              child: Text("Approve"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(width: 8),
            TextButton(
              onPressed: () {
                showRejectDialog(context, product);
              },
              child: Text("Reject"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    ],
  );
}

void showApproveDialog(BuildContext context, Product product) {
  final TextEditingController priceController =
      TextEditingController(text: product.shopkeeperPrice?.toString());
  final TextEditingController offerController =
      TextEditingController(text: (product.shopkeeperOfferPrice ?? "").toString());

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: bgColor,
      title: Text("Approve Product: ${product.name}", style: TextStyle(color: primaryColor)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _suggestionItem("Suggested Price", "\u20B9${product.shopkeeperPrice}"),
                ),
                Expanded(
                  child: _suggestionItem("Suggested Offer", "\u20B9${product.shopkeeperOfferPrice ?? 0}"),
                ),
              ],
            ),
            Divider(color: Colors.white12, height: 24),
            Text("Final Pricing", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Selling Price (MRP)",
                labelStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(),
                prefixText: "\u20B9 ",
                prefixStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: offerController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Offer Price (Discounted)",
                labelStyle: TextStyle(color: Colors.greenAccent),
                border: OutlineInputBorder(),
                prefixText: "\u20B9 ",
                prefixStyle: TextStyle(color: Colors.white),
                helperText: "Customers will pay this amount",
                helperStyle: TextStyle(color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            double sellingPrice = double.tryParse(priceController.text) ?? 0;
            double? offerPrice = double.tryParse(offerController.text);
            
            if (sellingPrice > 0) {
              context.read<VendorProductProvider>().approveProduct(product, sellingPrice, offerPrice);
              Navigator.pop(context);
            } else {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter a valid selling price")),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text("Approve & Publish"),
        ),
      ],
    ),
  );
}

Widget _suggestionItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: Colors.white38, fontSize: 10)),
      Text(value, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    ],
  );
}

void showRejectDialog(BuildContext context, Product product) {
  final TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: bgColor,
      title: Text("Reject Product: ${product.name}", style: TextStyle(color: primaryColor)),
      content: TextField(
        controller: reasonController,
        maxLines: 3,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Rejection Reason",
          labelStyle: TextStyle(color: Colors.white70),
          hintText: "Explain why this product is being rejected",
          hintStyle: TextStyle(color: Colors.white38),
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            String reason = reasonController.text.trim();
            if (reason.isNotEmpty) {
              context.read<VendorProductProvider>().rejectProduct(product, reason);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please provide a reason for rejection")),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Reject Product"),
        ),
      ],
    ),
  );
}

void showProductDetailDialog(BuildContext context, Product product) {
  var size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: bgColor,
      title: Text("Product Details", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
      content: Container(
        width: size.width * 0.5,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.images != null && product.images!.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.images!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.images![index].url!, 
                          height: 200, 
                          width: 200, 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            width: 200,
                            color: Colors.white10,
                            child: Icon(Icons.error, color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              _detailItem("Name", product.name),
              _detailItem("Description", product.description),
              _detailItem("Vendor Price", "\u20B9${product.shopkeeperPrice}"),
              _detailItem("Quantity", "${product.quantity} ${product.unit ?? ''}"),
              _detailItem("Category", product.proCategoryId?.name),
              _detailItem("Sub Category", product.proSubCategoryId?.name),
              _detailItem("Brand", product.proBrandId?.name),
              _detailItem("Variant Type", product.proVariantTypeId?.type),
              _detailItem("Is Available", (product.isAvailable ?? true) ? "Yes" : "No"),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

Widget _detailItem(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryColor)),
        SizedBox(height: 4),
        Text(value ?? 'N/A', style: TextStyle(fontSize: 14, color: Colors.white)),
        Divider(color: Colors.white12),
      ],
    ),
  );
}

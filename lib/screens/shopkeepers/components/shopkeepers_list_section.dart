import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/data_provider.dart';
import '../../../../models/user.dart';
import '../../../../utility/constants.dart';
import '../../../../utility/extensions.dart';
import '../provider/shopkeeper_provider.dart';

class ShopkeepersListSection extends StatelessWidget {
  const ShopkeepersListSection({
    Key? key,
  }) : super(key: key);

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
            "All Shopkeepers",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                // Filter users by role 'shopkeeper'
                final shopkeepers = dataProvider.users.where((u) => u.role == 'shopkeeper').toList();

                return ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 800),
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("Shop Name"),
                      ),
                      DataColumn(
                        label: Text("Vendor Name"),
                      ),
                      DataColumn(
                        label: Text("Email"),
                      ),
                      DataColumn(
                        label: Text("Status"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),
                    ],
                    rows: List.generate(
                      shopkeepers.length,
                      (index) => shopkeeperDataRow(context, shopkeepers[index]),
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

DataRow shopkeeperDataRow(BuildContext context, User shopkeeperInfo) {
  return DataRow(
    cells: [
      DataCell(Text(shopkeeperInfo.shopName ?? 'No Shop Name')),
      DataCell(Text(shopkeeperInfo.name ?? 'No Name')),
      DataCell(Text(shopkeeperInfo.email ?? 'No Email')),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: shopkeeperInfo.shopStatus == 'active'
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            shopkeeperInfo.shopStatus?.toUpperCase() ?? 'ACTIVE',
            style: TextStyle(
              color: shopkeeperInfo.shopStatus == 'active' ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<ShopkeeperProvider>().updateShopStatus(shopkeeperInfo);
              },
              icon: Icon(
                shopkeeperInfo.shopStatus == 'active' ? Icons.block : Icons.check_circle,
                color: shopkeeperInfo.shopStatus == 'active' ? Colors.orange : Colors.green,
              ),
              tooltip: shopkeeperInfo.shopStatus == 'active' ? 'Deactivate' : 'Activate',
            ),
            IconButton(
              onPressed: () {
                showAssignCategoriesDialog(context, shopkeeperInfo);
              },
              icon: Icon(
                Icons.category,
                color: Colors.blue,
              ),
              tooltip: 'Assign Categories',
            ),
          ],
        ),
      ),
    ],
  );
}

void showAssignCategoriesDialog(BuildContext context, User shopkeeper) {
  final dataProvider = context.read<DataProvider>();
  final allCategories = dataProvider.categories;
  final allSubCategories = dataProvider.subCategories;
  
  List<String> selectedCategories = List<String>.from(shopkeeper.assignedCategories ?? []);
  List<String> selectedSubCategories = List<String>.from(shopkeeper.assignedSubCategories ?? []);

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text("Assign Access to ${shopkeeper.shopName}"),
        content: Container(
          width: 500,
          height: 500,
          child: ListView.builder(
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final cat = allCategories[index];
              final categorySubCats = allSubCategories.where((sc) => sc.categoryId?.sId == cat.sId).toList();
              
              bool isCategorySelected = selectedCategories.contains(cat.sId);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: Text(cat.name ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: isCategorySelected,
                    activeColor: primaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedCategories.add(cat.sId!);
                        } else {
                          selectedCategories.remove(cat.sId);
                          // Optional: Clear subcategories if category is unselected?
                          // Let's keep them but they won't be usable if category is not assigned
                          final subCatIdsToRemove = categorySubCats.map((sc) => sc.sId).toList();
                          selectedSubCategories.removeWhere((id) => subCatIdsToRemove.contains(id));
                        }
                      });
                    },
                  ),
                  if (categorySubCats.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Column(
                        children: categorySubCats.map((subCat) {
                          return CheckboxListTile(
                            title: Text(subCat.name ?? '', style: TextStyle(fontSize: 14)),
                            value: selectedSubCategories.contains(subCat.sId),
                            enabled: isCategorySelected, // Only allow subcategory selection if category is selected
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedSubCategories.add(subCat.sId!);
                                } else {
                                  selectedSubCategories.remove(subCat.sId);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<ShopkeeperProvider>().assignCategories(
                shopkeeper, 
                selectedCategories, 
                selectedSubCategories
              );
              Navigator.pop(context);
            },
            child: Text("Assign", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    ),
  );
}

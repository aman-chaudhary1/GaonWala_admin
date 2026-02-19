import 'package:sazedar_admin/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import 'add_product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({
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
            "All Products",
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - (defaultPadding * 2),
                    ),
                    child: DataTable(
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(
                          label: Text("Product Name"),
                        ),
                        DataColumn(
                          label: Text("Category"),
                        ),
                        DataColumn(
                          label: Text("Sub Category"),
                        ),
                        DataColumn(
                          label: Text("Price"),
                        ),
                        DataColumn(
                          label: Text("Stock"),
                        ),
                        DataColumn(
                          label: Text("Status"),
                        ),
                        DataColumn(
                          label: Text("Edit"),
                        ),
                        DataColumn(
                          label: Text("Delete"),
                        ),
                      ],
                      rows: List.generate(
                        dataProvider.products.length,
                        (index) => productDataRow(dataProvider.products[index], edit: () {
                          showAddProductForm(context, dataProvider.products[index]);
                        },
                          delete: () {
                            //TODO: should complete call deleteProduct(compleyte)
                            context.dashBoardProvider.deleteProduct(dataProvider.products[index]);
                          },),
                      ),
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

DataRow productDataRow(Product productInfo, {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (productInfo.images != null && productInfo.images!.isNotEmpty)
              Image.network(
                productInfo.images!.first.url ?? '',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Icon(Icons.error, size: 30);
                },
              )
            else
              Icon(Icons.image, size: 30),
            SizedBox(width: defaultPadding),
            Flexible(
              child: Text(
                productInfo.name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          productInfo.proCategoryId?.name ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      DataCell(
        Text(
          productInfo.proSubCategoryId?.name ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      DataCell(
        Text(
          '${productInfo.price}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          '${productInfo.quantity}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          (productInfo.isAvailable ?? true) ? 'Available' : 'Unavailable',
          style: TextStyle(
            color: (productInfo.isAvailable ?? true) ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
      ),
    ],
  );
}

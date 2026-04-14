import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/data_provider.dart';
import '../../../../models/user.dart';
import '../../../../utility/constants.dart';
import '../../../../utility/extensions.dart';

class UsersListSection extends StatelessWidget {
  const UsersListSection({
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
            "All Users",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 600),
                  child: DataTable(
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("Name"),
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
                      dataProvider.users.length,
                      (index) => userDataRow(context, dataProvider.users[index]),
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

DataRow userDataRow(BuildContext context, User userInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              backgroundImage: userInfo.profileImage != null
                  ? NetworkImage(userInfo.profileImage!)
                  : null,
              child: userInfo.profileImage == null ? Icon(Icons.person) : null,
              radius: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(userInfo.name ?? 'No Name'),
            ),
          ],
        ),
      ),
      DataCell(Text(userInfo.email ?? 'No Email')),
      DataCell(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: userInfo.userStatus == 'active'
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            userInfo.userStatus?.toUpperCase() ?? 'ACTIVE',
            style: TextStyle(
              color: userInfo.userStatus == 'active' ? Colors.green : Colors.red,
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
                context.userProvider.updateUserStatus(userInfo);
              },
              icon: Icon(
                userInfo.userStatus == 'active' ? Icons.block : Icons.check_circle,
                color: userInfo.userStatus == 'active' ? Colors.orange : Colors.green,
              ),
              tooltip: userInfo.userStatus == 'active' ? 'Deactivate' : 'Activate',
            ),
            IconButton(
              onPressed: () {
                showDeleteDialog(context, userInfo);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

void showDeleteDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete User"),
      content: Text("Are you sure you want to delete ${user.name}?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            context.userProvider.deleteUser(user);
            Navigator.pop(context);
          },
          child: Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

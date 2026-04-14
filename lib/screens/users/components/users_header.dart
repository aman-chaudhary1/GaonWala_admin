import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/data_provider.dart';
import '../../../../utility/responsive.dart';
import '../../../../utility/constants.dart';

class UsersHeader extends StatelessWidget {
  const UsersHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isMobile(context))
          Text(
            "Users",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: 2),
        Expanded(
          child: SearchField(),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<DataProvider>().filterUsers(value);
      },
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: Container(
          padding: EdgeInsets.all(defaultPadding * 0.75),
          margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}

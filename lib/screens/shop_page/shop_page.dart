// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:money_manager/screens/shop_page/components/shop_bottom_modal.dart';

class ShopPage extends StatefulWidget {
  String? shopName;
  String? shopId;
  ShopPage({Key? key, @required this.shopName, @required this.shopId})
      : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          widget.shopName!,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            return ShopBottomModal(uid: widget.shopId);
          },
        ),
      ),
    );
  }
}

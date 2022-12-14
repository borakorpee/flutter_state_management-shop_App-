// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_thema/app_thema.dart';
import '../providers/auth.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../screens/detail_page/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final appThema app_thema = appThema();

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: true);
    final authData = Provider.of<Auth>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ProductDetailScreen(product.id),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: product.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Hero(
                          tag: "${product.id}",
                          child: Image.network(product.imageUrl),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 3,
                  ),
                  child: FittedBox(
                    child: Text(
                      product.title,
                      style: TextStyle(color: app_thema.text, fontSize: 16),
                    ),
                  ),
                ),
                Text(
                  " \$ ${product.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: app_thema.text,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            child: IconButton(
                icon: Icon(context.watch<Products>().isFav(product.id)
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavorite(
                    authData.token,
                    authData.userId,
                  );
                }),
            top: -2,
          ),
        ],
      ),
    );
  }
}

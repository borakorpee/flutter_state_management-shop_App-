// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_thema/app_thema.dart';
import '../../providers/products_provider.dart';
import 'components/add_to_cart.dart';
import 'components/appbar_icon.dart';
import 'components/description.dart';
import 'components/product_title_and_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;

  ProductDetailScreen(this.id);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int activeColor_index = 0;
  final appThema app_thema = appThema();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(widget.id);
    return Scaffold(
      backgroundColor: loadedProduct.colorOptions[activeColor_index],
      appBar: AppBar(
        backgroundColor: loadedProduct.colorOptions[activeColor_index],
        elevation: 0,
        actions: <Widget>[
          AppBarIcons(icon: Icon(Icons.favorite_border)),
          AppBarIcons(icon: Icon(Icons.shopping_cart_outlined)),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: size.height * 0.12, left: 20, right: 20),
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Color"),
                                Row(
                                  children: [
                                    ...List.generate(
                                        loadedProduct.colorOptions.length,
                                        (index) {
                                      return GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            activeColor_index = index;
                                          });
                                        }),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, right: 10),
                                          padding: EdgeInsets.all(2.5),
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: activeColor_index == index
                                                  ? loadedProduct.color
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: loadedProduct
                                                  .colorOptions[index],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Description(loadedProduct: loadedProduct),
                        AddToCart(
                            loadedProduct: loadedProduct,
                            activeColor_index: activeColor_index,
                            app_thema: app_thema),
                      ],
                    ),
                  ),
                  ProductTitleAndImage(
                    loadedProduct: loadedProduct,
                    app_thema: app_thema,
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

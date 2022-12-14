// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';
import '../../app_thema/app_thema.dart';
import '../../providers/cart.dart';
import '../../providers/products_provider.dart';
import '../../widgets/badge.dart';
import '../cart_screen.dart';
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
  int numOfItems = 1;
  Widget animation = null;
  final appThema app_thema = appThema();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: true,
    ).findById(widget.id);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: loadedProduct.colorOptions[activeColor_index],
          appBar: AppBar(
            backgroundColor: loadedProduct.colorOptions[activeColor_index],
            actions: <Widget>[
              IconButton(
                icon: Icon(loadedProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .toggleFavoritee(loadedProduct.id);
                },
              ),
              Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart_sharp),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 230,
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 400,
                            padding: EdgeInsets.only(
                                top: size.height * 0.10, left: 20, right: 20),
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
                                ColorOptions(loadedProduct),
                                Description(loadedProduct: loadedProduct),
                                Row(
                                  children: <Widget>[
                                    buildOutlinedButton(Icons.remove, () {
                                      if (numOfItems > 1) {
                                        setState(() {
                                          numOfItems--;
                                        });
                                        ;
                                      }
                                    }),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        numOfItems.toString().padLeft(2, "0"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    buildOutlinedButton(Icons.add, () {
                                      setState(() {
                                        numOfItems++;
                                      });
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ProductTitleAndImage(
                            loadedProduct: loadedProduct,
                            app_thema: app_thema,
                            activeColor_index: activeColor_index,
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 20),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: loadedProduct
                                        .colorOptions[activeColor_index],
                                  ),
                                ),
                                child: RawMaterialButton(
                                  onPressed: () {
                                    cart.addItemCount(
                                      loadedProduct.id,
                                      loadedProduct.price,
                                      loadedProduct.title,
                                      numOfItems,
                                      loadedProduct
                                          .productPhotos[activeColor_index],
                                    );
                                    setState(() {
                                      animation = CartAnimation();
                                    });
                                    Future.delayed(Duration(seconds: 2), () {
                                      setState(() {
                                        animation = null;
                                      });
                                    });
                                  },
                                  constraints: BoxConstraints(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Icon(
                                    Icons.add_shopping_cart_outlined,
                                    color: loadedProduct
                                        .colorOptions[activeColor_index],
                                  ),
                                  padding: EdgeInsets.all(8),
                                )),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  color: loadedProduct.colorOptions == null
                                      ? loadedProduct.color
                                      : loadedProduct
                                          .colorOptions[activeColor_index],
                                  child: Text(
                                    "Buy Now".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: app_thema.white),
                                  ),
                                  onPressed: () {
                                    cart.addItemCount(
                                      loadedProduct.id,
                                      loadedProduct.price,
                                      loadedProduct.title,
                                      numOfItems,
                                      loadedProduct
                                          .productPhotos[activeColor_index],
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                        CartScreen.routeName);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: animation == null ? Container() : CartAnimation(),
        ),
      ],
    );
  }

  ColorOptions(Product loadedProduct) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Color"),
            Row(
              children: [
                ...List.generate(loadedProduct.colorOptions.length, (index) {
                  return GestureDetector(
                    onTap: (() {
                      setState(() {
                        activeColor_index = index;
                      });
                    }),
                    child: Container(
                      margin: EdgeInsets.only(top: 5, right: 10),
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
                          color: loadedProduct.colorOptions[index],
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
    );
  }

  buildOutlinedButton(IconData icon, Function press) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13))),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}

class CartAnimation extends StatefulWidget {
  const CartAnimation({Key key}) : super(key: key);

  @override
  State<CartAnimation> createState() => _CartAnimationState();
}

class _CartAnimationState extends State<CartAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final Size biggest = constraints.biggest;
      return Stack(
        children: [
          PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                    Rect.fromLTRB(
                      25,
                      biggest.height - 160,
                      40,
                      biggest.height,
                    ),
                    biggest),
                end: RelativeRect.fromSize(
                    Rect.fromLTRB(
                      biggest.width - 70,
                      -50,
                      biggest.width,
                      200,
                    ),
                    biggest),
              ).animate(CurvedAnimation(
                  parent: _controller, curve: Curves.decelerate)),
              child: Icon(Icons.shopping_cart, color: Colors.black))
        ],
      );
    });
  }
}

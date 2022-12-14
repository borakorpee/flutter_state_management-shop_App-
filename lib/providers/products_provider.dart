import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*
    Product(
      id: 'p1',
      title: 'Fancy Bag',
      description: 'A red shirt - it is pretty red!',
      longDescription:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eget efficitur metus. Vestibulum venenatis nisl id tincidunt blandit. Proin risus dui, ultricies sit amet mi quis, pellentesque dignissim massa. Duis quis ligula ut tortor ornare venenatis. Fusce nec tincidunt est. Pellentesque venenatis odio auctor accumsan congue.",
      price: 29.99,
      imageUrl:
          'https://www.freeiconspng.com/thumbs/bag-png/clothing-bag-png-1.png',
      color: Colors.brown,
      productPhotos: [
        "https://www.freeiconspng.com/thumbs/bag-png/clothing-bag-png-1.png",
      ],
      colorOptions: [
        Color.fromRGBO(139, 38, 43, 1),
      ],
    ),
    Product(
      id: 'p2',
      title: 'iPhone 14 Pro Max',
      description: 'Smarter then ever',
      longDescription:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam eget efficitur metus. Vestibulum venenatis nisl id tincidunt blandit. Proin risus dui, ultricies sit amet mi quis, pellentesque dignissim massa. Duis quis ligula ut tortor ornare venenatis. Fusce nec tincidunt est. Pellentesque venenatis odio auctor accumsan congue.",
      price: 499.99,
      imageUrl:
          'https://static1.pocketnowimages.com/wordpress/wp-content/uploads/2022/09/PBI-iPhone-14-Deep-Purple-1.png?q=50&fit=crop&w=1920&dpr=1.5',
      color: Color.fromRGBO(77, 66, 83, 1),
      productPhotos: [
        'https://static1.pocketnowimages.com/wordpress/wp-content/uploads/2022/09/PBI-iPhone-14-Deep-Purple-1.png?q=50&fit=crop&w=1920&dpr=1.5',
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-14-pro-max-gold-select?wid=940&hei=1112&fmt=png-alpha&.v=1660777235605',
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-14-pro-spaceblack-select?wid=940&hei=1112&fmt=png-alpha&.v=1660777235198',
        'https://d1erhn8sljv386.cloudfront.net/CA-HugmnEptyeQ9bJSwBeExZy9Q=/fit-in/1000x1000/filters:format(webp)/https://s3.amazonaws.com/lmbucket0/media/product/t-mobile-apple-iphone-14-pro-max-frontimage-silver.png',
      ],
      colorOptions: [
        Color.fromRGBO(77, 66, 83, 1),
        Color.fromARGB(255, 233, 203, 143),
        Color.fromRGBO(49, 47, 46, 1),
        Colors.grey,
      ],
    )*/
  ];

  bool isFav(String id) {
    Product prod = _items.firstWhere((element) => element.id == id);
    return prod.isFavorite;
  }

  void toggleFavoritee(String id) {
    Product prod = _items.firstWhere((element) => element.id == id);
    prod.isFavorite = !prod.isFavorite;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items].where((proditem) => proditem.isFavorite).toList();
  }

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);
  Future<void> fetchAndSetProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://flutter-shop-app-79429-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          'https://flutter-shop-app-79429-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken';
      final fetchFavoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(fetchFavoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            longDescription: prodData['longDescription'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageURL'],
            color: Color(prodData['color']),
            colorOptions: [Color(prodData['color'])],
            productPhotos: [prodData['imageURL']]));
      });
      _items = loadedProducts;
      // I want to keep my dummy datas
      //_items.removeRange(2, _items.length);

      /*loadedProducts.forEach((prod) {
        if (!_items.contains(prod.id)) {
          _items.add(prod);
        }
      });
*/
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-app-79429-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'longDescription': product.longDescription,
            'imageURL': product.imageUrl,
            'price': product.price,
            'color': product.color.value,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        longDescription: product.longDescription,
        price: product.price,
        imageUrl: product.imageUrl,
        color: Color(product.color.value),
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-app-79429-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'longDescription': newProduct.longDescription,
            'price': newProduct.price,
            'imageURL': newProduct.imageUrl,
            'color': newProduct.color.value,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  void deleteProduct(String id) {
    final url =
        'https://flutter-shop-app-79429-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    http.delete(Uri.parse(url));
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:ofypets_mobile_app/models/product.dart';
import 'package:ofypets_mobile_app/widgets/rating_bar.dart';
import 'package:ofypets_mobile_app/scoped-models/main.dart';
import 'package:ofypets_mobile_app/screens/cart.dart';
import 'package:ofypets_mobile_app/widgets/shopping_cart_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  ProductDetailScreen(this.product);
  @override
  State<StatefulWidget> createState() {
    return _ProductDetailScreenState();
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Size _deviceSize;
  int quantity = 1;
  Product selectedProduct;
  bool _hasVariants = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    if (widget.product.hasVariants) {
      _hasVariants = widget.product.hasVariants;
      selectedProduct = widget.product.variants.first;
    } else {
      selectedProduct = widget.product;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Item Details'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            shoppingCartIconButton()
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: 'HIGHLIGHTS',
              ),
              Tab(
                text: 'REVIEWS',
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[highlightsTab(), Text('REVIEWS')],
        ),
        floatingActionButton: addToCartFAB());
  }

  Widget highlightsTab() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 300,
                    child: FadeInImage(
                      image: NetworkImage(selectedProduct.image),
                      placeholder: AssetImage(
                          'images/placeholders/no-product-image.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            width: _deviceSize.width,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ratingBar(selectedProduct.avgRating, 20),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(selectedProduct.reviewsCount)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              selectedProduct.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                'Quantity: ',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (quantity > 1) {
                  setState(() {
                    quantity = quantity - 1;
                  });
                }
              },
            ),
            Text(quantity.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  quantity = quantity + 1;
                });
              },
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Price :',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  selectedProduct.displayPrice,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          addToCartFlatButton()
        ],
      ),
    );
  }

  Widget addToCartFlatButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
              selectedProduct.isOrderable ? 'ADD TO CART' : 'OUT OF STOCK'),
          onPressed: () {
            if (selectedProduct.isOrderable) {
              model.addProduct(
                  variantId: selectedProduct.id, quantity: quantity);
            }
          },
        );
      },
    );
  }

  Widget addToCartFAB() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return FloatingActionButton(
          child: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          onPressed: () {
            selectedProduct.isOrderable
                ? model.addProduct(
                    variantId: selectedProduct.id, quantity: quantity)
                : null;
          },
          backgroundColor:
              selectedProduct.isOrderable ? Colors.orange : Colors.grey,
        );
      },
    );
  }
}

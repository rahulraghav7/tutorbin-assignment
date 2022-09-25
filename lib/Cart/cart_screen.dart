import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import '../Models/cart_model.dart';
import 'cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blocCart.getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: blocCart.subject.stream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data is CartModel) {
            return _buildCartWidget(context);
          } else {
            return loading(context);
          }
        });
  }

  Widget _buildCartWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: blocCart.tileList.length,
                  itemBuilder: (context, index) {
                    return renderCategoryTile(index);
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          placeOrderButton(context),
        ],
      ),
    );
  }

  Card renderCategoryTile(int index) {
    return Card(
      child: ExpansionTile(
          title: Row(
            children: [
              Text(blocCart.cat[index]),
              const Spacer(),
              Visibility(
                visible: blocCart.tileList[index].total != 0,
                child: Text(blocCart.tileList[index].total.toString()),
              )
            ],
          ),
          children: [
            SingleChildScrollView(
              child: renderProductList(index),
            )
          ]),
    );
  }

  Widget placeOrderButton(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        //  width:  MediaQuery.of(context).size.width*0.9,
        margin: const EdgeInsets.fromLTRB(10,0,10,10),
        child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                // backgroundColor: MaterialStateProperty.all<Color>(),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.red)))),
            onPressed: () => {
                  if (blocCart.totalPrice == 0)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please Add At Least 1 Product"),
                      ))
                    }
                  else
                    {
                      CoolAlert.show(
                        //loopAnimation: true,
                        confirmBtnColor: const  Color(0xffF16821),
                        onConfirmBtnTap: () {
                          blocCart.calculateBestSeller();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        context: context,
                        type: CoolAlertType.success,
                        text: "Your order was placed successfully!",
                      ),
                    }
                },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Place Order ".toUpperCase(),
                    style: const TextStyle(fontSize: 14)),
                Visibility(
                    visible: blocCart.totalPrice != 0,
                    child: const SizedBox(
                      width: 25,
                    )),
                Visibility(
                    visible: blocCart.totalPrice != 0,
                    child: Text("₹ ${blocCart.totalPrice}"))
              ],
            )),
      ),
    );
  }

  ListView renderProductList(int index) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: blocCart.tileList[index].items?.length,
        itemBuilder: (context, index2) {
          return renderProductTile(index, index2, context);
        });
  }

  ListTile renderProductTile(int index, int index2, BuildContext context) {
    return ListTile(
        subtitle: Text(
            "₹ ${blocCart.tileList[index].items?[index2].price.toString() ?? ''}"),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            //  mainAxisSize: MainAxisSize.min,
            children: blocCart.tileList[index].items?[index2].inStock != null &&
                    blocCart.tileList[index].items?[index2].inStock == true
                ? [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if ((blocCart.tileList[index].items?[index2]
                                        .quantity ??
                                    0) >
                                0) {
                              blocCart
                                  .tileList[index].items?[index2].quantity--;
                              blocCart.tileList[index].total--;
                              blocCart.totalPrice -= blocCart
                                      .tileList[index].items?[index2].price ??
                                  0;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle)),
                    Text(blocCart.tileList[index].items?[index2].quantity
                            .toString() ??
                        ''),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            blocCart.tileList[index].items?[index2].quantity++;
                            blocCart.tileList[index].total++;
                            blocCart.totalPrice +=
                                blocCart.tileList[index].items?[index2].price ??
                                    0;
                          });
                        },
                        icon: const Icon(Icons.add_circle))
                  ]
                : [
                    const Text(
                      'OUT OF STOCK',
                      style: TextStyle(color: Color(0xff868C92)),
                    )
                  ],
          ),
        ),
        title: Row(
          children: [
            Text(blocCart.tileList[index].items?[index2].name ?? ''),
            const SizedBox(
              width: 7,
            ),
            Visibility(
              visible:
                  blocCart.tileList[index].items?[index2].isBestSeller ?? false,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xff9F2B00),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Best Seller',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )),
            ),
          ],
        ));
  }

  Widget loading(BuildContext context, {bool showNavBar = true}) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Cart",
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: Center(
            child: Container(
                margin: const EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                ))));
  }
}

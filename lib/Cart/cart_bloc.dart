import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import '../Data/cart_data.dart';
import '../Models/cart_model.dart';

class CartBloc {
  late CartModel cartData;
  List<Tile> tileList = [];
  List<String> cat = [];
  int totalPrice = 0;

  final BehaviorSubject<dynamic> _subject = BehaviorSubject<dynamic>();

  getData() async {
    _subject.sink.add(null);
    cartData = CartModel.fromJson(jsonDecode(CartData.data));
    tileList.addAll([
      Tile(cartData.cat1),
      Tile(cartData.cat2),
      Tile(cartData.cat3),
      Tile(cartData.cat4),
      Tile(cartData.cat5),
      Tile(cartData.cat6),
    ]);
    cat.addAll(CartData().categories);
    await Future.delayed(const Duration(seconds: 2));

    _subject.sink.add(cartData);
  }

  calculateBestSeller() {
    List totalQuantity = [];
    for (var i in tileList) {
      for (var j in i.items ?? []) {
        j.previousOrderQuantity += j.quantity;
        totalQuantity.add(j.previousOrderQuantity);
        j.quantity = 0;
        j.isBestSeller = false;
      }
    }
    totalQuantity.sort();
    totalQuantity =
        totalQuantity.sublist(totalQuantity.length - 3, totalQuantity.length);
    enableBestSeller(totalQuantity);
  }

  enableBestSeller(List bestSellerQuantity) async {
    int count = 0;
    _subject.sink.add(null);
    await Future.delayed(const Duration(seconds: 1));

    for (var i in tileList) {
      i.total = 0;

      for (var j in i.items ?? []) {
        if (bestSellerQuantity.contains(j.previousOrderQuantity) &&
            j.previousOrderQuantity != 0) {
          if (count < 3) {
            j.isBestSeller = true;
          }
          count++;
        }
      }
    }
    totalPrice = 0;
    _subject.sink.add(cartData);
  }

  BehaviorSubject<dynamic> get subject => _subject;
}

class Tile {
  final List<Cat>? items;
  int total = 0;

  Tile(this.items);
}

final CartBloc blocCart = CartBloc();

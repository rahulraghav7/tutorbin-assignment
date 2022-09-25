class CartModel {
  List<Cat>? cat1;
  List<Cat>? cat2;
  List<Cat>? cat3;
  List<Cat>? cat4;
  List<Cat>? cat5;
  List<Cat>? cat6;

  CartModel({this.cat1, this.cat2, this.cat3, this.cat4, this.cat5, this.cat6});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['cat1'] != null) {
      cat1 = <Cat>[];
      json['cat1'].forEach((v) {
        cat1!.add(new Cat.fromJson(v));
      });
    }
    if (json['cat2'] != null) {
      cat2 = <Cat>[];
      json['cat2'].forEach((v) {
        cat2!.add(new Cat.fromJson(v));
      });
    }
    if (json['cat3'] != null) {
      cat3 = <Cat>[];
      json['cat3'].forEach((v) {
        cat3!.add(new Cat.fromJson(v));
      });
    }
    if (json['cat4'] != null) {
      cat4 = <Cat>[];
      json['cat4'].forEach((v) {
        cat4!.add(new Cat.fromJson(v));
      });
    }
    if (json['cat5'] != null) {
      cat5 = <Cat>[];
      json['cat5'].forEach((v) {
        cat5!.add(new Cat.fromJson(v));
      });
    }
    if (json['cat6'] != null) {
      cat6 = <Cat>[];
      json['cat6'].forEach((v) {
        cat6!.add(new Cat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cat1 != null) {
      data['cat1'] = this.cat1!.map((v) => v.toJson()).toList();
    }
    if (this.cat2 != null) {
      data['cat2'] = this.cat2!.map((v) => v.toJson()).toList();
    }
    if (this.cat3 != null) {
      data['cat3'] = this.cat3!.map((v) => v.toJson()).toList();
    }
    if (this.cat4 != null) {
      data['cat4'] = this.cat4!.map((v) => v.toJson()).toList();
    }
    if (this.cat5 != null) {
      data['cat5'] = this.cat5!.map((v) => v.toJson()).toList();
    }
    if (this.cat6 != null) {
      data['cat6'] = this.cat6!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cat {
  String? name;
  int? price;
  bool? inStock;
  int quantity=0;
  int previousOrderQuantity=0;
  bool isBestSeller=false;

  Cat({this.name, this.price, this.inStock,required this.quantity});

  Cat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    inStock = json['instock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['instock'] = this.inStock;
    return data;
  }
}

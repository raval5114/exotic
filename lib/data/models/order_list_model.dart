class OrderListModel {
  final String? orderId;
  final String? orderStatus;
  final String? date;
  final String? productName;
  final String? productImage;
  final num? price;
  final int? quantity;
  final String? paymentStatus;
  final String? deliveryAddress;
  final PriceBreakdown? priceBreakdown;
  final List<DeliveryUpdate>? deliveryUpdates;

  OrderListModel({
    this.orderId,
    this.orderStatus,
    this.date,
    this.productName,
    this.productImage,
    this.price,
    this.quantity,
    this.paymentStatus,
    this.deliveryAddress,
    this.priceBreakdown,
    this.deliveryUpdates,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    return OrderListModel(
      orderId: json['orderId'],
      orderStatus: json['orderStatus'],
      date: json['date'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'],
      quantity: json['quantity'],
      paymentStatus: json['paymentStatus'],
      deliveryAddress: json['deliveryAddress'],
      priceBreakdown: json['priceBreakdown'] != null
          ? PriceBreakdown.fromJson(json['priceBreakdown'])
          : null,
      deliveryUpdates: json['deliveryUpdates'] != null
          ? (json['deliveryUpdates'] as List)
              .map((e) => DeliveryUpdate.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderStatus': orderStatus,
      'date': date,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'paymentStatus': paymentStatus,
      'deliveryAddress': deliveryAddress,
      'priceBreakdown': priceBreakdown?.toJson(),
      'deliveryUpdates': deliveryUpdates?.map((e) => e.toJson()).toList(),
    };
  }
}

class PriceBreakdown {
  final num? listPrice;
  final num? sellingPrice;
  final num? deliveryCharge;
  final num? handlingFee;
  final num? platformFee;
  final num? totalAmount;

  PriceBreakdown({
    this.listPrice,
    this.sellingPrice,
    this.deliveryCharge,
    this.handlingFee,
    this.platformFee,
    this.totalAmount,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) {
    return PriceBreakdown(
      listPrice: json['listPrice'],
      sellingPrice: json['sellingPrice'],
      deliveryCharge: json['deliveryCharge'],
      handlingFee: json['handlingFee'],
      platformFee: json['platformFee'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listPrice': listPrice,
      'sellingPrice': sellingPrice,
      'deliveryCharge': deliveryCharge,
      'handlingFee': handlingFee,
      'platformFee': platformFee,
      'totalAmount': totalAmount,
    };
  }
}

class DeliveryUpdate {
  final String? status;
  final String? timestamp;
  final List<Subtask>? subtasks;

  DeliveryUpdate({
    this.status,
    this.timestamp,
    this.subtasks,
  });

  factory DeliveryUpdate.fromJson(Map<String, dynamic> json) {
    return DeliveryUpdate(
      status: json['status'],
      timestamp: json['timestamp'],
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List).map((e) => Subtask.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
      'subtasks': subtasks?.map((e) => e.toJson()).toList(),
    };
  }
}

class Subtask {
  final String? status;
  final String? timestamp;

  Subtask({
    this.status,
    this.timestamp,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
    };
  }
}

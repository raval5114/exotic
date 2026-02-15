import 'package:exotic/data/repositories/orderList/orderRepo.dart';

class OrderlistRepo extends IOrderRepo {
  @override
  Future<List<Map<String, dynamic>>> fetchUserOderList() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      return [
        {
          "orderId": "ORD1001",
          "orderStatus": "Delivered",
          "date": "June 20, 2025",
          "productName": "Apple iPhone 15 Pro Max - 256GB",
          "productImage": "assets/images/products/iphone15.png",
          "price": 139999,
          "quantity": 1,
          "paymentStatus": "Paid",
          "deliveryAddress": "Wayne Tower, 1007 Mountain Drive, Gotham City",
          "priceBreakdown": {
            "listPrice": 149999,
            "sellingPrice": 139999,
            "deliveryCharge": 0,
            "handlingFee": 20,
            "platformFee": 10,
            "totalAmount": 140029,
          },
          "deliveryUpdates": [
            {
              "status": "Order Confirmed Thu, 1st May '25",
              "timestamp": "2025-05-01T19:24:00",
              "subtasks": [
                {
                  "status": "Your Order has been placed.",
                  "timestamp": "2025-05-01T19:24:00",
                },
                {
                  "status": "Seller is processing your order.",
                  "timestamp": "2025-05-01T20:00:00",
                },
                {
                  "status": "Item waiting to be picked up by courier partner.",
                  "timestamp": "2025-05-02T16:00:00",
                },
              ],
            },
            {
              "status": "Shipped Sat, 3rd May '25",
              "timestamp": "2025-05-03T12:28:00",
              "subtasks": [
                {
                  "status": "Logistics - FMPC4628089281",
                  "timestamp": "2025-05-03T12:00:00",
                },
                {
                  "status": "Your item has been shipped.",
                  "timestamp": "2025-05-03T12:28:00",
                },
                {
                  "status": "Item received in the hub nearest to you",
                  "timestamp": "2025-05-03T18:00:00",
                },
              ],
            },
            {
              "status": "Out For Delivery Sun, 4th May '25",
              "timestamp": "2025-05-04T07:54:00",
              "subtasks": [
                {
                  "status": "Your item is out for delivery",
                  "timestamp": "2025-05-04T07:54:00",
                },
              ],
            },
            {
              "status": "Delivered Sun, 4th May '25",
              "timestamp": "2025-05-04T19:04:00",
              "subtasks": [
                {
                  "status": "Your item has been delivered",
                  "timestamp": "2025-05-04T19:04:00",
                },
              ],
            },
          ],
        },
        {
          "orderId": "ORD1002",
          "orderStatus": "Canceled On",
          "date": "June 18, 2025",
          "productName": "Sony WH-1000XM5 Wireless Headphones",
          "productImage": "assets/images/products/sony_headphones.png",
          "price": 29999,
          "quantity": 1,
          "paymentStatus": "Refunded",
          "deliveryAddress": "20, Arkham Street, Gotham East",
          "priceBreakdown": {
            "listPrice": 32999,
            "sellingPrice": 29999,
            "deliveryCharge": 40,
            "handlingFee": 10,
            "platformFee": 5,
            "totalAmount": 30054,
          },
          "deliveryUpdates": [
            {
              "status": "Order Confirmed Tue, 11th June '25",
              "timestamp": "2025-06-11T14:15:00",
              "subtasks": [
                {
                  "status": "Your Order has been placed.",
                  "timestamp": "2025-06-11T14:15:00",
                },
                {
                  "status": "Seller is processing your order.",
                  "timestamp": "2025-06-11T15:00:00",
                },
              ],
            },
            {
              "status": "Order canceled on Wed, 18th June '25",
              "timestamp": "2025-06-18T10:30:00",
              "subtasks": [
                {
                  "status": "Refund initiated",
                  "timestamp": "2025-06-18T10:45:00",
                },
              ],
            },
          ],
        },
        {
          "orderId": "ORD1003",
          "orderStatus": "Delivering by",
          "date": "June 30, 2025",
          "productName": "Samsung Galaxy Watch 6",
          "productImage": "assets/images/products/galaxy_watch.png",
          "price": 19999,
          "quantity": 1,
          "paymentStatus": "Paid",
          "deliveryAddress": "100 Gotham Tech Park, Block B, Gotham City",
          "priceBreakdown": {
            "listPrice": 22999,
            "sellingPrice": 19999,
            "deliveryCharge": 0,
            "handlingFee": 8,
            "platformFee": 3,
            "totalAmount": 20010,
          },
          "deliveryUpdates": [
            {
              "status": "Order Confirmed Thu, 20th June '25",
              "timestamp": "2025-06-20T11:00:00",
              "subtasks": [
                {
                  "status": "Your Order has been placed.",
                  "timestamp": "2025-06-20T11:00:00",
                },
                {
                  "status": "Seller is processing your order.",
                  "timestamp": "2025-06-20T12:30:00",
                },
              ],
            },
            {
              "status": "Item waiting to be picked up by courier partner",
              "timestamp": "2025-06-21T10:00:00",
              "subtasks": [
                {
                  "status": "Packed and ready for pickup",
                  "timestamp": "2025-06-21T09:45:00",
                },
              ],
            },
            {
              "status": "Shipped (Expected by Mon, 24th June)",
              "timestamp": null,
              "subtasks": [
                {"status": "Item in transit to Gotham hub", "timestamp": null},
              ],
            },
            {
              "status": "Out for delivery",
              "timestamp": null,
              "subtasks": [
                {"status": "Courier out for delivery", "timestamp": null},
              ],
            },
            {
              "status": "Delivery expected by Sun, 30th June",
              "timestamp": null,
              "subtasks": [
                {
                  "status": "Delivery to be attempted before 9PM",
                  "timestamp": null,
                },
              ],
            },
          ],
        },
        {
          "orderId": "ORD1004",
          "orderStatus": "Delivered",
          "date": "June 10, 2025",
          "productName": "Nike Air Max 270",
          "productImage": "assets/images/products/nike_airmax.png",
          "price": 12999,
          "quantity": 2,
          "paymentStatus": "Paid",
          "deliveryAddress": "45 Midtown Lane, Gotham Heights",
          "priceBreakdown": {
            "listPrice": 14999,
            "sellingPrice": 12999,
            "deliveryCharge": 40,
            "handlingFee": 5,
            "platformFee": 2,
            "totalAmount": 13046,
          },
          "deliveryUpdates": [
            {
              "status": "Order Confirmed Sat, 1st June '25",
              "timestamp": "2025-06-01T09:00:00",
              "subtasks": [
                {
                  "status": "Your Order has been placed.",
                  "timestamp": "2025-06-01T09:00:00",
                },
                {
                  "status": "Seller is processing your order.",
                  "timestamp": "2025-06-01T11:00:00",
                },
              ],
            },
            {
              "status": "Item picked up by courier partner",
              "timestamp": "2025-06-02T08:00:00",
              "subtasks": [
                {
                  "status": "Shipment assigned",
                  "timestamp": "2025-06-02T08:00:00",
                },
              ],
            },
            {
              "status": "Shipped",
              "timestamp": "2025-06-03T10:30:00",
              "subtasks": [
                {
                  "status": "Left origin hub",
                  "timestamp": "2025-06-03T11:00:00",
                },
              ],
            },
            {
              "status": "Out for delivery",
              "timestamp": "2025-06-10T08:30:00",
              "subtasks": [
                {
                  "status": "Courier dispatched",
                  "timestamp": "2025-06-10T08:30:00",
                },
              ],
            },
            {
              "status": "Delivered",
              "timestamp": "2025-06-10T13:10:00",
              "subtasks": [
                {
                  "status": "Package received by resident",
                  "timestamp": "2025-06-10T13:10:00",
                },
              ],
            },
          ],
        },
        {
          "orderId": "ORD1005",
          "orderStatus": "Canceled On",
          "date": "June 15, 2025",
          "productName": "Lenovo Legion 5 Pro Gaming Laptop",
          "productImage": "assets/images/products/legion_laptop.png",
          "price": 159999,
          "quantity": 1,
          "paymentStatus": "Refunded",
          "deliveryAddress": "Elite Techno Society, Wayne Street, Gotham",
          "priceBreakdown": {
            "listPrice": 169999,
            "sellingPrice": 159999,
            "deliveryCharge": 100,
            "handlingFee": 30,
            "platformFee": 20,
            "totalAmount": 160149,
          },
          "deliveryUpdates": [
            {
              "status": "Order Confirmed Mon, 10th June '25",
              "timestamp": "2025-06-10T16:00:00",
              "subtasks": [
                {
                  "status": "Your Order has been placed.",
                  "timestamp": "2025-06-10T16:00:00",
                },
                {
                  "status": "Seller is processing your order.",
                  "timestamp": "2025-06-10T17:30:00",
                },
              ],
            },
            {
              "status": "Order canceled on Sun, 15th June '25",
              "timestamp": "2025-06-15T09:45:00",
              "subtasks": [
                {
                  "status": "Refund initiated to original payment method",
                  "timestamp": "2025-06-15T10:00:00",
                },
              ],
            },
          ],
        },
        {
          "orderId": "ORD1006",
          "orderStatus": "Delivering by",
          "date": "July 2, 2025",
          "productName": "Mi Smart LED TV 50-inch",
          "productImage": "assets/images/products/mi_tv.png",
          "price": 42999,
          "quantity": 1,
          "paymentStatus": "Paid",
          "deliveryAddress": "Penthouse, Skyline Residency, Gotham City",
          "priceBreakdown": {
            "listPrice": 49999,
            "sellingPrice": 42999,
            "deliveryCharge": 0,
            "handlingFee": 15,
            "platformFee": 5,
            "totalAmount": 43019,
          },
          "deliveryUpdates": [
            {
              "status": "Order Confirmed Wed, 26th June '25",
              "timestamp": "2025-06-26T13:10:00",
              "subtasks": [
                {
                  "status": "Your Order has been placed.",
                  "timestamp": "2025-06-26T13:10:00",
                },
                {
                  "status": "Seller is processing your order.",
                  "timestamp": "2025-06-26T15:00:00",
                },
              ],
            },
            {
              "status": "Item waiting to be picked up by courier partner",
              "timestamp": "2025-06-27T10:00:00",
              "subtasks": [
                {
                  "status": "Courier has been assigned",
                  "timestamp": "2025-06-27T10:10:00",
                },
              ],
            },
            {
              "status": "Shipped (Expected by Sun, 30th June)",
              "timestamp": null,
              "subtasks": [
                {"status": "In transit to final hub", "timestamp": null},
              ],
            },
            {
              "status": "Out for delivery",
              "timestamp": null,
              "subtasks": [
                {"status": "Delivery vehicle en route", "timestamp": null},
              ],
            },
            {
              "status": "Delivery expected by Tue, 2nd July",
              "timestamp": null,
              "subtasks": [
                {
                  "status": "Delivery slot booked for 9AM–12PM",
                  "timestamp": null,
                },
              ],
            },
          ],
        },
      ];
    } catch (e) {
      rethrow;
    }
  }
}

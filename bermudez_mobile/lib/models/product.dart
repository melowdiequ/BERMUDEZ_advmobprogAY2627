class Product {


  final int id;

  final String title;

  final String description;

  final String category;

  final String brand;

  final double price;

  final double rating;

  final int stock;

  final String thumbnail;

  final double weight;

  final String dimensions;

  final String warrantyInformation;

  final String shippingInformation;

  final String returnPolicy;



  Product({


    required this.id,

    required this.title,

    required this.description,

    required this.category,

    required this.brand,

    required this.price,

    required this.rating,

    required this.stock,

    required this.thumbnail,

    required this.weight,

    required this.dimensions,

    required this.warrantyInformation,

    required this.shippingInformation,

    required this.returnPolicy,


  });




  factory Product.fromJson(Map<String, dynamic> json) {


    return Product(


      id: json['id'] ?? 0,


      title: json['title'] ?? '',


      description: json['description'] ?? '',


      category: json['category'] ?? '',


      brand: json['brand'] ?? '',


      price: (json['price'] ?? 0).toDouble(),


      rating: (json['rating'] ?? 0).toDouble(),


      stock: json['stock'] ?? 0,


      thumbnail: json['thumbnail'] ?? '',



      weight: (json['weight'] ?? 0).toDouble(),



      dimensions:

      json['dimensions'] != null

          ? "${json['dimensions']['width']} x ${json['dimensions']['height']} x ${json['dimensions']['depth']}"

          : "Not available",




      warrantyInformation:

      json['warrantyInformation'] ?? "Not available",



      shippingInformation:

      json['shippingInformation'] ?? "Not available",



      returnPolicy:

      json['returnPolicy'] ?? "Not available",


    );


  }


}
class Apartment {
  final int id;
  final String price;
  final String space;
  final String status;
  final int addressId;
  final String image;

  Apartment({
    required this.id,
    required this.price,
    required this.space,
    required this.status,
    required this.addressId,
    required this.image,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json["id"],
      price: json["price"],
      space: json["space"],
      status: json["statusApartments"],
      addressId: json["adress_Id"],
      image: json["image"],
    );
  }
}
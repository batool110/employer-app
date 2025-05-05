class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String referredBy;
  final String pictureUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.referredBy,
    required this.pictureUrl,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'role': role,
        'referredBy': referredBy,
        'pictureUrl': pictureUrl,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        address: map['address'],
        role: map['role'],
        referredBy: map['referredBy'],
        pictureUrl: map['pictureUrl'],
      );
}

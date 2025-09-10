// To parse this JSON data, do
//
//     final customerRegisterPostReponse = customerRegisterPostReponseFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostReponse customerRegisterPostReponseFromJson(String str) =>
    CustomerRegisterPostReponse.fromJson(json.decode(str));

String customerRegisterPostReponseToJson(CustomerRegisterPostReponse data) =>
    json.encode(data.toJson());

class CustomerRegisterPostReponse {
  String message;
  Register register;

  CustomerRegisterPostReponse({required this.message, required this.register});

  factory CustomerRegisterPostReponse.fromJson(Map<String, dynamic> json) =>
      CustomerRegisterPostReponse(
        message: json["message"],
        register: Register.fromJson(json["register"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "register": register.toJson(),
  };
}

class Register {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  Register({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    idx: json["idx"],
    fullname: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}

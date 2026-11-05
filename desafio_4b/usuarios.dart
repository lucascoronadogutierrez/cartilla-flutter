import 'dart:convert';

class Address {
  final String city;
  final String zipcode;

  Address({required this.city, required this.zipcode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
    );
  }

  @override
  String toString() {
    return '$id - $name (@$username) - $email - ${address.city} ${address.zipcode}';
  }
}

void main() {
  String jsonUnUsuario = '''
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "address": {
      "street": "Kulas Light",
      "city": "Gwenborough",
      "zipcode": "92998-3874"
    }
  }
  ''';

  Map<String, dynamic> mapa = jsonDecode(jsonUnUsuario);
  User usuario = User.fromJson(mapa);
  print(usuario);

  String jsonLista = '''
  [
    {
      "id": 1,
      "name": "Leanne Graham",
      "username": "Bret",
      "email": "Sincere@april.biz",
      "address": { "city": "Gwenborough", "zipcode": "92998-3874" }
    },
    {
      "id": 2,
      "name": "Ervin Howell",
      "username": "Antonette",
      "email": "Shanna@melissa.tv",
      "address": { "city": "Wisokyburgh", "zipcode": "90566-7771" }
    }
  ]
  ''';

  List<dynamic> lista = jsonDecode(jsonLista);
  List<User> usuarios = lista.map((item) => User.fromJson(item)).toList();

  for (User u in usuarios) {
    print(u);
  }
}

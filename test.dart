void main() {
  String name1 = 'Liam';
  String playerName(String? name) => name ?? 'Guest';
  playerName(name1);
  print(playerName(null));

  var products = [
    {"name": "Screwdriver", "price": 42.00},
    {"name": "Wingnut", "price": 0.50}
  ];
  var values = products.map((product) => product['price'] as double);
  print(values);
}

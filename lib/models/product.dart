class Product {
  final String id;
  final String title;
  final String imagePath;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.price,
  });
}

final List<Product> dummyProducts = [
  Product(
    id: 'p1',
    title: 'Classic Qotton Hoodie',
    imagePath: 'img/product/1.png',
    price: 15.00,
  ),
  Product(
    id: 'p2',
    title: 'Minimalist Dark Hoodie',
    imagePath: 'img/product/2.png',
    price: 15.00,
  ),
  Product(
    id: 'p3',
    title: 'Essential Qotton Hoodie',
    imagePath: 'img/product/3.png',
    price: 15.00,
  ),
  Product(
    id: 'p4',
    title: 'Signature Zip Hoodie',
    imagePath: 'img/product/4.png',
    price: 15.00,
  ),
  Product(
    id: 'p5',
    title: 'Premium Comfort Hoodie',
    imagePath: 'img/product/5.png',
    price: 15.00,
  ),
  Product(
    id: 'p7',
    title: 'Anime X Qotton Collab',
    imagePath: 'img/product/7.png',
    price: 15.00,
  ),
  Product(
    id: 'p8',
    title: 'Akatsuki Cloud Anime Hoodie',
    imagePath: 'img/product/8.png',
    price: 15.00,
  ),
  Product(
    id: 'p9',
    title: 'Hunter License Anime Edition',
    imagePath: 'img/product/9.png',
    price: 15.00,
  ),
  Product(
    id: 'p10',
    title: 'Titan Core Anime Hoodie',
    imagePath: 'img/product/10.png',
    price: 15.00,
  ),
  Product(
    id: 'p11',
    title: 'Shinobi Origin Anime Drop',
    imagePath: 'img/product/11.png',
    price: 15.00,
  ),
  Product(
    id: 'p12',
    title: 'Dragon Ball Anime Exclusive',
    imagePath: 'img/product/12.png',
    price: 15.00,
  ),
];

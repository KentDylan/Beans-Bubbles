class MenuModel {
  final int id;
  final String name;
  final int price;
  final String imageUrl;
  final bool isFavorite;
  final String category;
  final String description;

  MenuModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.imageUrl,
      required this.isFavorite,
      required this.category,
      required this.description});

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'category': category,
      'description': description,
    };
  }
}

final List<MenuModel> listMenu = [
  MenuModel(
    id: 01,
    name: 'Croissant + Cold Brew',
    price: 30000,
    imageUrl: 'assets/img/croissbrew.png',
    isFavorite: true,
    category: 'Deals',
    description:
        "Wake up to a perfect morning with our Breakfast Bliss Combo Deal! Complement your croissant with our refreshing Cold Brew Coffee, expertly brewed to a smooth, bold finish. It's the perfect companion to your croissant, providing a cool and invigorating caffeine kick.",
  ),
  MenuModel(
    id: 02,
    name: 'Pain au Chocolate+ Croissant',
    price: 30000,
    imageUrl: 'assets/img/croau.png',
    isFavorite: false,
    category: 'Deals',
    description: "Experience the best of French pastries with our French Pastry Duos Combo Deal! Indulge in the perfect pairing of our Pain au Chocolat and Classic Croissant for a taste of authentic French pastry craftsmanship.",
  ),
  MenuModel(
    id: 03,
    name: 'Choux au Craquelin + Cream Puff',
    price: 15000,
    imageUrl: 'assets/img/chouxpuff.png',
    isFavorite: true,
    category: 'Deals',
    description: "Indulge in a symphony of pastry perfection with our Pastry Delight Duo Combo Deal! Savor the exquisite combination of Choux au Craquelin and Cream Puff, a duo that showcases the best of our pastry craftsmanship.",
  ),
  MenuModel(
    id: 04,
    name: 'Coffee Bun + Melonpan',
    price: 18000,
    imageUrl: 'assets/img/panbun.png',
    isFavorite: false,
    category: 'Deals',
    description:
        "Experience the ultimate baked goodness duet with our Coffee Bun + Melonpan Combo Deal! Enjoy the irresistible combination of our Coffee Bun and Melonpan, a duet that celebrates the art of baking.",
  ),
  MenuModel(
    id: 10,
    name: 'Cookies Ring',
    price: 10000,
    imageUrl: 'assets/img/donut4.webp',
    isFavorite: false,
    category: 'Donut',
    description:
        "Donut berbentuk ring lembut dengan topping coklat putih dan taburan oreo.",
  ),
  MenuModel(
    id: 11,
    name: 'Almond Roll',
    price: 10000,
    imageUrl: 'assets/img/donut3.webp',
    isFavorite: true,
    category: 'Donut',
    description:
        "Donut berbentuk ring lembut dengan topping coklat putih dan taburan kacang almond.",
  ),
  MenuModel(
    id: 12,
    name: 'Choco Pie',
    price: 12000,
    imageUrl: 'assets/img/donut5.webp',
    isFavorite: true,
    category: 'Donut',
    description:
        "Donut shell lembut dengan isian custard coklat dan topping coklat.",
  ),
  MenuModel(
    id: 13,
    name: 'Berry Pie',
    price: 12000,
    imageUrl: 'assets/img/donut6.webp',
    isFavorite: true,
    category: 'Donut',
    description:
        "Donut shell lembut dengan isian selai strawberry dan topping coklat.",
  ),
  MenuModel(
    id: 14,
    name: 'Choco Crunchy Tart',
    price: 15000,
    imageUrl: 'assets/img/donut7.webp',
    isFavorite: false,
    category: 'Donut',
    description:
        "Donut tart lembut dengan isian custard coklat dan topping coklat.",
  ),
  MenuModel(
    id: 15,
    name: 'Choco Cheese Tart',
    price: 10000,
    imageUrl: 'assets/img/donut8.webp',
    isFavorite: false,
    category: 'Donut',
    description:
        "Donut tart lembut dengan isian custard coklat dan topping coklat keju.",
  ),
  MenuModel(
    id: 16,
    name: 'Mochido Honey',
    price: 12000,
    imageUrl: 'assets/img/donut9.webp',
    isFavorite: false,
    category: 'Donut',
    description:
        "Donut kenyal seperti mochi dengan baluran Glaze manis.",
  ),
  MenuModel(
    id: 17,
    name: 'Mochido Eclair',
    price: 12000,
    imageUrl: 'assets/img/donut10.webp',
    isFavorite: true,
    category: 'Donut',
    description:
        "Donut kenyal seperti mochi dengan isi custard susu dan coklat.",
  ),
  MenuModel(
    id: 20,
    name: 'Classic Butter Croissant',
    price: 27500,
    imageUrl: 'assets/img/croissant1.webp',
    isFavorite: true,
    category: 'Pastry',
    description:
        "Croissant original.",
  ),
  MenuModel(
    id: 21,
    name: 'Boston Cream Croissant',
    price: 35000,
    imageUrl: 'assets/img/croissant2.webp',
    isFavorite: false,
    category: 'Pastry',
    description:
        "Diisi dengan krim vanilla rhum (non alkohol).",
  ),
  MenuModel(
    id: 22,
    name: 'Red Velvet Croissant',
    price: 40000,
    imageUrl: 'assets/img/croissant3.webp',
    isFavorite: true,
    category: 'Pastry',
    description:
        "Diisi dengan cream keju.",
  ),
  MenuModel(
    id: 23,
    name: 'Cromboloni Matcha',
    price: 25000,
    imageUrl: 'assets/img/cromboloni1.webp',
    isFavorite: false,
    category: 'Pastry',
    description:
        "Diisi dengan cream matcha Jepang import."
,
  ),
  MenuModel(
    id: 24,
    name: 'Cromboloni Tiramisu',
    price: 27000,
    imageUrl: 'assets/img/cromboloni2.webp',
    isFavorite: false,
    category: 'Pastry',
    description:
        "Diisi dengan cream kopi ringan."
,
  ),
  MenuModel(
    id: 25,
    name: 'Cromboloni Lemon Squeeze',
    price: 22000,
    imageUrl: 'assets/img/cromboloni3.webp',
    isFavorite: true,
    category: 'Pastry',
    description:
        "Diisi dengan cream lemon yang manis dan fresh.",
  ),
  MenuModel(
    id: 30,
    name: 'Coffee Latte',
    price: 18000,
    imageUrl: 'assets/img/coffee1.webp',
    isFavorite: true,
    category: 'Drinks',
    description:
        "Kopi, Susu, & Gula Aren.",
  ),
  MenuModel(
    id: 31,
    name: 'Americano',
    price: 16000,
    imageUrl: 'assets/img/coffee9.webp',
    isFavorite: true,
    category: 'Drinks',
    description:
        "Espresso dan Air Mineral.",
  ),
  MenuModel(
    id: 32,
    name: 'Vanilla Latte',
    price: 28000,
    imageUrl: 'assets/img/coffee3.webp',
    isFavorite: false,
    category: 'Drinks',
    description:
        "Espresso dan susu dengan sirup vanilla.",
  ),
  MenuModel(
    id: 33,
    name: 'Avocado Coffee',
    price: 27000,
    imageUrl: 'assets/img/coffee4.webp',
    isFavorite: true,
    category: 'Drinks',
    description:
        "Espresso dan alpukat",
  ),
  MenuModel(
    id: 34,
    name: 'Caramel Latte',
    price: 26000,
    imageUrl: 'assets/img/coffee5.webp',
    isFavorite: true,
    category: 'Drinks',
    description:
        'Espresso, Susu, dan Sirup Karamel.',
  ),
  MenuModel(
    id: 35,
    name: 'Dua Shot Ice Shaken',
    price: 28000,
    imageUrl: 'assets/img/coffee6.webp',
    isFavorite: false,
    category: 'Drinks',
    description:
        'Double Espresso Shot',
  ),
    MenuModel(
    id: 36,
    name: 'OG Chocolate Cookie',
    price: 15000,
    imageUrl: 'assets/img/cookie1.webp',
    isFavorite: false,
    category: 'Pastry',
    description:
        "Original cookie dengan toping chococips.",
  ),
  MenuModel(
    id: 37,
    name: 'White Walnut Cookie',
    price: 13000,
    imageUrl: 'assets/img/cookie2.webp',
    isFavorite: false,
    category: 'Pastry',
    description:
        "Cookie dengan toping walnut panggang dan coklat putih."
,
  ),
  MenuModel(
    id: 38,
    name: 'Fudgy Matcha Cookie',
    price: 22000,
    imageUrl: 'assets/img/cookie3.webp',
    isFavorite: true,
    category: 'Pastry',
    description:
        "Cookie dengan adonan matcha dan topping coklat putih.",
  ),
];

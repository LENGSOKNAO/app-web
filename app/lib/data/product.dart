import 'package:app/core/assets/png.dart';
import 'package:app/model/product.dart';

final List<ModelProduct> dataProduct = [
  ModelProduct(
    name: 'Nike Air Max',
    image: [ImagePng.product1],
    descrition:
        'The Nike Air Max combines lightweight cushioning with breathable mesh to deliver comfort that lasts all day. Designed for running and casual wear, its iconic Air unit absorbs impact, making every step smooth and effortless.',
    price: 120.0,
    category: 'Shoes',
    color: 'Black',
    qty: 10,
    time: '2h',
    sizes: [
      "40",
      "41",
      "42",
      "43",
      "44",
      "39",
      "40",
      "41",
      "42",
      "S",
      "M",
      "L",
      "XL",
    ],
  ),
  ModelProduct(
    name: 'Nike Jordan 1',
    image: [ImagePng.product2],
    descrition:
        'Step into history with the legendary Nike Jordan 1. Crafted with premium leather and bold color contrasts, this sneaker represents culture, performance, and timeless style. Whether on the court or the streets, it makes a powerful statement.',
    price: 200.0,
    category: 'Shoes',
    color: 'Red/White',
    qty: 5,
    time: '5h',
    sizes: ["40", "41", "42", "43"],
  ),
  ModelProduct(
    name: 'Nike Dunk Low',
    image: [ImagePng.product3],
    descrition:
        'The Nike Dunk Low is a lifestyle essential that blends sporty vibes with casual flair. Featuring durable leather uppers and a padded low-cut collar, it is perfect for everyday wear, delivering comfort and a stylish edge to any outfit.',
    price: 150.0,
    category: 'Shoes',
    color: 'Blue',
    qty: 8,
    time: '1d',
    sizes: ["39", "40", "41", "42", "S", "M", "L", "XL"],
  ),
  ModelProduct(
    name: 'Nike Running Tee',
    image: [ImagePng.product4],
    descrition:
        'Stay cool and dry with the Nike Running Tee. Made from moisture-wicking fabric, this lightweight t-shirt is built to handle the toughest workouts. Its ergonomic fit provides freedom of movement, making it perfect for both training and daily wear.',
    price: 35.0,
    category: 'Clothing',
    color: 'White',
    qty: 25,
    time: '3d',
    sizes: ["S", "M", "L", "XL"],
  ),
  ModelProduct(
    name: 'Nike Sports Shorts',
    image: [ImagePng.product5],
    descrition:
        'Train harder and move freely with the Nike Sports Shorts. Featuring breathable fabric and a flexible design, these shorts are ideal for gym sessions, running, or casual wear. Built for durability, they keep you comfortable every step of the way.',
    price: 40.0,
    category: 'Clothing',
    color: 'Black',
    qty: 15,
    time: '6h',
    sizes: ["S", "M", "L", "XL"],
  ),
  ModelProduct(
    name: 'Nike Cap',
    image: [ImagePng.product6],
    descrition:
        'Complete your look with the Nike Cap, designed with an adjustable strap for a personalized fit. Made with durable cotton and breathable eyelets, it offers comfort and style for both workouts and casual outings. A must-have accessory for every athlete.',
    price: 20.0,
    category: 'Accessories',
    color: 'Navy',
    qty: 30,
    time: '12h',
    sizes: ["Free Size"],
  ),
];

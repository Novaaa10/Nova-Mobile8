import 'package:flutter/material.dart';
import 'package:tugas7/models/cart.dart';
import 'package:tugas7/models/product.dart';
import 'package:tugas7/screens/cartscreen.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product('Foundation', 125000.0, 'foundation'),
      Product('Cushion', 89000.0, 'cushion'),
      Product('Lip Tint', 65000.0, 'lip_tint'),
      Product('Lip Matte', 75000.0, 'lip_matte'),
      Product('Blush On', 55000.0, 'blush'),
    ];

    // Function untuk mendapatkan icon berdasarkan nama produk
IconData getProductIcon(String productName) {
  switch (productName.toLowerCase()) {
    case 'foundation':
      return Icons.face_retouching_natural;
    case 'cushion':
      return Icons.airline_seat_flat;
    case 'lip_tint':
    case 'lip_matte':
      return Icons.favorite; // Ganti dengan favorite atau circle
    case 'blush':
      return Icons.color_lens;
    default:
      return Icons.shopping_bag;
  }
}

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F6),
      appBar: AppBar(
        title: const Text(
          'Katalog Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFE75480),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                return Badge(
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFFE75480),
                  label: Text('${cart.totalItems}'),
                  isLabelVisible: cart.totalItems > 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  getProductIcon(product.imageAsset),
                  size: 30,
                  color: const Color(0xFFE75480),
                ),
              ),
              title: Text(
                product.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'Rp ${product.harga.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFFE75480),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4EC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false).add(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.nama} ditambahkan ke keranjang'),
                        backgroundColor: const Color(0xFFE75480),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: Color(0xFFE75480),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
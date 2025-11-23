import 'package:flutter/material.dart';
import 'package:tugas7/models/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F6),
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFE75480),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Keranjang Kosong',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF6F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            product.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.face_retouching_natural,
                                color: const Color(0xFFE75480),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          product.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Rp ${product.harga.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFFE75480),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4EC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Provider.of<Cart>(context, listen: false).remove(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.nama} dihapus dari keranjang'),
                                  backgroundColor: const Color(0xFFE75480),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFE75480),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Belanja:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Rp ${cart.totalHarga.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE75480),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (cart.items.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'Pesanan Berhasil!',
                                  style: TextStyle(color: Color(0xFFE75480)),
                                ),
                                content: Text(
                                  'Terima kasih! Pesanan ${cart.totalItems} item dengan total Rp ${cart.totalHarga.toStringAsFixed(0)} berhasil dibuat.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<Cart>(context, listen: false).clear();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Color(0xFFE75480)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE75480),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Pesan Sekarang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
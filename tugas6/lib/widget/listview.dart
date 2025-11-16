import 'package:flutter/material.dart';
import 'package:tugas6/models/travel_model.dart';
import 'package:tugas6/screens/detail_screen.dart';

Widget listview() {
  Travel data = Travel();
  return ListView.builder(
    itemCount: data.travelData.length,
    itemBuilder: (context, index) {
      final item = data.travelData[index];
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image'] ?? "TIDAK ADA GAMBAR",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[600]),
                );
              },
            ),
          ),
          title: Text(
            item['title'] ?? "TIDAK ADA JUDUL",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            item['location'] ?? "Lokasi tidak tersedia",
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(wisata: item),
              ),
            );
          },
        ),
      );
    },
  );
}
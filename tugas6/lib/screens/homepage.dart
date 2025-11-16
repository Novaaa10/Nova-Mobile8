import 'package:flutter/material.dart';
import 'package:tugas6/widget/gridview.dart';
import 'package:tugas6/widget/listview.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //fungsinya bikin halaman jadi tab
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Katalog Wisata',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Listview'),
              Tab(icon: Icon(Icons.grid_on), text: 'GridView'),
            ],
          ),
        ),
        body: TabBarView(children: [listview(), gridview()]),
      ),
    );
  }
}

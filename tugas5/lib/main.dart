import 'package:flutter/material.dart';
import 'api_service.dart';
import 'article_model.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Berita',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NewsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> _articlesFuture;
  // Controller untuk mengontrol posisi scroll ListView
  final ScrollController _scrollController = ScrollController();
  // State untuk melacak apakah tombol "kembali ke atas" harus ditampilkan
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    // Memuat artikel saat inisialisasi
    _articlesFuture = _fetchArticles();
    
    // Menambahkan listener ke ScrollController
    _scrollController.addListener(() {
      // Tampilkan tombol jika scroll position melebihi 400 pixel
      if (_scrollController.offset >= 400 && !_showBackToTopButton) {
        setState(() {
          _showBackToTopButton = true;
        });
      } 
      // Sembunyikan tombol jika kembali ke atas
      else if (_scrollController.offset < 400 && _showBackToTopButton) {
        setState(() {
          _showBackToTopButton = false;
        });
      }
    });
  }

  // Fungsi untuk memuat artikel, dapat dipanggil lagi untuk refresh
  Future<List<Article>> _fetchArticles() {
    return ApiService().fetchArticle();
  }

  // Fungsi untuk refresh data
  Future<void> _refreshArticles() async {
    setState(() {
      _articlesFuture = _fetchArticles();
    });
  }

  // Fungsi untuk kembali ke atas
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Terkini (Indonesia)'),
        actions: [
          // Tombol Refresh di AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshArticles, // Panggil fungsi refresh
          ),
        ],
      ),
      body: RefreshIndicator( // Widget untuk fungsionalitas pull-to-refresh
        onRefresh: _refreshArticles,
        child: FutureBuilder<List<Article>>(
          future: _articlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final articles = snapshot.data!;
              return ListView.builder(
                // Tambahkan controller ke ListView
                controller: _scrollController, 
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.urlToImage != null)
                            Image.network(
                              article.urlToImage!,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported, size: 50);
                              },
                            ),
                          const SizedBox(height: 10),
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(article.description ?? 'Tidak ada deskripsi.'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                // Tambahkan ListView kosong dengan controller dan RefreshIndicator 
                // agar pull-to-refresh tetap berfungsi saat tidak ada data
                child: ListView( 
                  controller: _scrollController,
                  children: const [
                    SizedBox(height: 200), // Memberi sedikit ruang
                    Center(child: Text('Tidak ada berita yang ditemukan.')),
                  ],
                ),
              );
            }
          },
        ),
      ),
      // Floating Action Button untuk kembali ke atas
      floatingActionButton: _showBackToTopButton 
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null, // Sembunyikan tombol jika _showBackToTopButton false
    );
  }
}
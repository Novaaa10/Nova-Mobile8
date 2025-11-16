import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:berita/article_model.dart';

class ApiService {
  static const _apiKey= '4a29528a9ed94337ae4ee8ec37b36d95';
  static const _baseName= 'https://newsapi.org/v2/everything?q=tesla&from=2025-09-26&sortBy=publishedAt&apiKey=$_apiKey';

  Future<List<Article>> fetchArticle() async{
    try{
      final response = await http.get(Uri.parse(_baseName));
      if(response.statusCode == 200){
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> articlesJson = json[ 'articles' ];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load Articles');
      }
    }catch(e){
      throw Exception('Failed to connect to server: $e');
    }
  }
}

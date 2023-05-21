import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsModel {
  final String title;
  final String imageUrl;
  final String content;

  NewsModel({required this.title, required this.imageUrl, required this.content});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      content: json['content'],
    );
  }
}

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<NewsModel> newsList = [];
  int currentPage = 1;
  int pageSize = 10; // Количество статей на одной странице
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        fetchNews();
      }
    });
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse('http://192.168.56.1/ServerForFlutter/api/restApi/GetArticlesApi?page=$currentPage&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        newsList.addAll(responseData.map((data) => NewsModel.fromJson(data)).toList());
        currentPage++; // Увеличиваем номер текущей страницы для следующего запроса
      });
    } else {
      // Обработка ошибок при получении данных из API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: newsList.length + 1, // +1 для отображения индикатора загрузки
        itemBuilder: (BuildContext context, int index) {
          if (index == newsList.length) {
            // Отображаем индикатор загрузки на последней позиции
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final news = newsList[index];

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0), // Добавляем вертикальный отступ
            child: ListTile(
              leading: Image.network(
                news.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(news.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(news: news),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  NewsDetailScreen({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Image.network(
                  news.imageUrl,
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                news.content,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListScreen(),
    );
  }
}

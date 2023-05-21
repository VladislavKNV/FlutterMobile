import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models.dart';



class CommentModel {
  final int id;
  final int idArticle;
  final String loginUser;
  final String comment;

  CommentModel({required this.id, required this.idArticle, required this.loginUser, required this.comment});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      idArticle: json['idArticle'],
      loginUser: json['LoginUser'],
      comment: json['Comment'],
    );
  }
}

class NewsDetailScreen extends StatefulWidget {
  final NewsModel news;
  final String login;

  NewsDetailScreen({required this.news, required this.login});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  TextEditingController _commentController = TextEditingController();
  List<CommentModel> _comments = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getComments();
  }

  Future<void> _getComments() async {
    final url = 'http://192.168.56.1/ServerForFlutter/api/restApi/GetCommentsApi';
    final requestBody = {
      "idArticle": widget.news.id,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<CommentModel> comments = data.map((item) => CommentModel.fromJson(item)).toList();

      setState(() {
        _comments = comments;
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'Ошибка при получении комментариев';
      });
    }
  }

  Future<void> _addComment() async {
    final url = 'http://192.168.56.1/ServerForFlutter/api/restApi/AddCommentApi';
    final requestBody = {
      "idArticle": widget.news.id,
      "LoginUser": widget.login,
      "Comment": _commentController.text,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Обновление страницы
      setState(() {
        _commentController.clear();
      });
      _getComments();
    } else {
      setState(() {
        _errorMessage = 'Ошибка при отправке комментария';
      });
    }
  }

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
                widget.news.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Image.network(
                  widget.news.imageUrl,
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.news.content,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Оставьте комментарий',
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _addComment,
                child: Text('Отправить'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Комментарии:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 8.0),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Пользователь: ${_comments[index].loginUser}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(_comments[index].comment),
                      SizedBox(height: 12.0),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

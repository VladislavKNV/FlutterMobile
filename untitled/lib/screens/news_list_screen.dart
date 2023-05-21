import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models.dart';
import 'news_detail_screen.dart';
import 'login_screen.dart';

String loginForCom = "null";

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<NewsModel> newsList = [];
  int currentPage = 1;
  int pageSize = 10; // Количество статей на одной странице
  ScrollController _scrollController = ScrollController();
  bool isLoggedIn = false;

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
    final client = http.Client();

    final response = await client.get(Uri.parse('http://192.168.56.1/ServerForFlutter/api/restApi/GetArticlesApi?page=$currentPage&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        newsList.addAll(responseData.map((data) => NewsModel.fromJson(data)).toList());
        currentPage++; // Увеличиваем номер текущей страницы для следующего запроса
      });
    } else {
      // Обработка ошибок при получении данных из API
    }

    client.close();
  }

  Future<void> login(String login, String password) async {
    final url = Uri.parse('http://192.168.56.1/ServerForFlutter/api/restApi/GetUserApi');
    final body = json.encode({
      "Login": login,
      "Password": password,
    });
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      // Сохраняем данные пользователя (выполняйте сохранение в соответствии с вашими требованиями)
      loginForCom = login;
      // ...

      setState(() {
        isLoggedIn = true;
      });
    } else {
      // Обработка ошибок авторизации
    }
  }

  Future<void> register(String login, String email, String password) async {
    final url = Uri.parse('http://192.168.56.1/ServerForFlutter/api/restApi/AddUserApi');
    final body = json.encode({
      "Login": login,
      "Email": email,
      "Password": password,
    });
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      // Сохраняем данные пользователя (выполняйте сохранение в соответствии с вашими требованиями)
      loginForCom = login;
      // ...

      setState(() {
        isLoggedIn = true;
      });
    } else {
      // Обработка ошибок регистрации
    }
  }

  void logout() {
    // Очищаем сохраненные данные пользователя (выполняйте очистку в соответствии с вашими требованиями)
    loginForCom = "null";
    // ...

    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return LoginScreen(login: login, register: register);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
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
                    builder: (context) => NewsDetailScreen(news: news, login: loginForCom),
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

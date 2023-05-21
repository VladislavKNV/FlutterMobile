import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String loginForCom = "null";

class NewsModel {
  final int id;
  final String title;
  final String imageUrl;
  final String content;

  NewsModel({required this.id, required this.title, required this.imageUrl, required this.content});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      content: json['content'],
    );
  }
}

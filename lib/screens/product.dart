import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Center(
        child: Text('Products Page.'),
      ),
    );
  }
}

import 'package:canteen_frontend/screens/request/request_grid.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  RequestScreen();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
      ),
      body: RequestGrid(),
    );
  }
}

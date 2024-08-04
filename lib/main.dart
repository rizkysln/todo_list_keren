import 'package:flutter/material.dart';
import 'screen.dart';

void main() => runApp(AplikasiTodo());

class AplikasiTodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Tugas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LayarDaftarTugas(),
    );
  }
}

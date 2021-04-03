import 'package:flutter/material.dart';
import 'app/task_manager.dart';

const Color primaryColor = Colors.blue;
const Color accentColor = Colors.blueGrey;
const bool isDark = false;

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primarySwatch: primaryColor,
        primaryColor: primaryColor,
        accentColor: accentColor,
        iconTheme: IconThemeData(color: accentColor)
      ),
      home: TaskManager(),
    ));
}

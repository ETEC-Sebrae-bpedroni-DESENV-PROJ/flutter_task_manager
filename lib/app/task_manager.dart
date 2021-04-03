import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final taskController = TextEditingController();

  List _taskList = [];

  @override
  void initState() {
    _readTasks().then((String data) {
      setState(() {
        _taskList = json.decode(data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gerenciador de Tarefas")),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Nova tarefa",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      )
                    ),
                    controller: taskController
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder()
                  ),
                  child: Icon(Icons.add, size: 50.0),
                  onPressed: _addTask
                )
              ]
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (ctx, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(_taskList[index]['text']),
                          value: _taskList[index]['checked'],
                          onChanged: (bool value) => _editTask(index, value)
                        )
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          final task = _taskList[index]['text'];
                          _removeTask(index);
                          final snackBar = SnackBar(
                            content: Text('A tarefa "$task" foi excluída'),
                            duration: Duration(seconds: 2)
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      )
                    ]
                  );
                }
              )
            )
          ]
        )
      )
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/tasks.json');
  }

  Future<String> _readTasks() async {
    final file = await _getFile();
    return await file.readAsString();
  }

  Future<void> _saveTasks() async {
    final file = await _getFile();
    file.writeAsString(json.encode(_taskList));
  }

  void _addTask() {
    if (taskController.text.trim() != '') {
      setState(() {
        _taskList.add({
          'text': taskController.text.trim(),
          'checked': false
        });
        taskController.text = '';
        _saveTasks();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _taskList.removeAt(index);
      _saveTasks();
    });
  }

  void _editTask(int index, bool value) {
    setState(() {
      _taskList[index]['checked'] = value;
      _saveTasks();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test2/Data/database.dart';
import 'package:test2/util/dialog_box.dart';
import 'package:test2/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {

    //first time ever opening the app
    if (_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }
    else{
      // there already exist data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();

  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        },
    );
  }

  // delete task
  void deleteTask(int index ){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        //title: Text("TO DO rayan"),
        title: Center(
          child: Text("TO DO Njutapmvoui_rayan_27"),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(
              Icons.add
          ),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context , index){
          return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value , index),
              deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}

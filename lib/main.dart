import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> todos = [];
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _editTodoController = TextEditingController();
  bool _isEditing = false;
  int _editingIndex = -1;

  static const Duration _snackBarDuration = Duration(seconds: 2);

  void _addTodo() {
    String newTodo = _todoController.text.trim();
    if (newTodo.isNotEmpty) {
      setState(() {
        todos.add(newTodo);
        _todoController.clear();
      });
    } else {
      _showErrorSnackBar('Por favor, digite uma tarefa antes de adicionar.');
    }
  }

  void _startEditing(int index) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _editTodoController.text = todos[index];
    });
  }

  void _editTodo() {
    setState(() {
      todos[_editingIndex] = _editTodoController.text.trim();
      _resetEditing();
    });
  }

  void _removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
      if (_isEditing && index == _editingIndex) {
        _resetEditing();
      }
    });
  }

  void _resetEditing() {
    setState(() {
      _isEditing = false;
      _editingIndex = -1;
      _editTodoController.clear();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: _snackBarDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de tarefas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          _buildInputRow(),
          Expanded(
            child: _buildTodoList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _isEditing ? _buildEditTextField() : _buildAddTextField(),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: _isEditing ? _editTodo : _addTodo,
            child: Text(_isEditing ? 'Salvar' : 'Adicionar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTextField() {
    return TextField(
      controller: _todoController,
      decoration: InputDecoration(
        hintText: 'Digite uma tarefa',
      ),
      onSubmitted: (_) => _addTodo(),
    );
  }

  Widget _buildEditTextField() {
    return TextField(
      controller: _editTodoController,
      decoration: InputDecoration(
        hintText: 'Editar tarefa',
      ),
      onSubmitted: (_) => _editTodo(),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(todos[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _startEditing(index),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeTodo(index),
              ),
            ],
          ),
        );
      },
    );
  }
}

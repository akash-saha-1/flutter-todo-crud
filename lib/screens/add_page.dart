import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_crud/helpers/snackbar_helper.dart';
import 'package:todo_crud/services/todo_service.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      titleController.text = todo?['title'];
      descController.text = todo?['description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add ToDo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    final id = todo?['_id'];
    final title = titleController.text;
    final description = descController.text;
    if (title.isEmpty || description.isEmpty) {
      return SnackBarHelper.showFailureMessage(
          context, 'Title or Description can not be empty!');
    }

    final success = await ToDoService.updateToDoById(id, body);

    if (success) {
      SnackBarHelper.showSuccessMessage(context, 'Updation Success');
    } else {
      SnackBarHelper.showFailureMessage(context, 'Updation Failure');
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descController.text;
    if (title.isEmpty || description.isEmpty) {
      return SnackBarHelper.showFailureMessage(
          context, 'Title or Description can not be empty!');
    }

    final success = await ToDoService.createToDo(body);

    if (success) {
      SnackBarHelper.showSuccessMessage(context, 'Creation Success');
      titleController.text = '';
      descController.text = '';
    } else {
      SnackBarHelper.showFailureMessage(context, 'Creation Failure');
    }
  }

  Map get body {
    return {
      "title": titleController.text,
      "description": descController.text,
      "is_completed": false
    };
  }
}

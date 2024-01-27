import 'package:flutter/material.dart';
import 'package:todo_crud/helpers/snackbar_helper.dart';
import 'package:todo_crud/screens/add_page.dart';
import 'package:todo_crud/services/todo_service.dart';
import 'package:todo_crud/widgets/todo_card.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    fetchToDo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(
            child: Text(
              'No Todo Item',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          child: RefreshIndicator(
              onRefresh: fetchToDo,
              child: ListView.builder(
                  itemCount: items.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final item = items[index] as Map;
                    final id = item['_id'] as String;
                    return ToDoCard(
                      index: index,
                      item: item,
                      navigateToAddPage: navigateToAddPage,
                      deleteById: deleteById,
                    );
                  })),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Row(
          children: [
            Icon(Icons.add), // Add the "+" icon
            SizedBox(width: 8), // Add spacing between icon and text
            Text('Add Todo'),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToAddPage([Map? item]) async {
    final route =
        MaterialPageRoute(builder: (context) => AddToDoPage(todo: item));
    await Navigator.push(context, route);
    await fetchToDo();
  }

  Future<void> deleteById(String id) async {
    bool isSuccess = await ToDoService.deleteById(id);
    if (isSuccess) {
      final filter = items.where((element) => element['_id'] != id).toList();
      SnackBarHelper.showSuccessMessage(context, 'Deletion Success');
      setState(() {
        items = filter;
      });
    } else {
      SnackBarHelper.showFailureMessage(context, 'Deletion Failed');
    }
  }

  Future<void> fetchToDo() async {
    setState(() {
      isLoading = true;
    });
    final result = await ToDoService.fetchToDo();
    if (result != null) {
      setState(() {
        items = result;
      });
    } else {
      SnackBarHelper.showFailureMessage(context, 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}

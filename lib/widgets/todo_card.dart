import 'package:flutter/material.dart';
import 'package:todo_crud/screens/add_page.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateToAddPage;
  final Function(String) deleteById;

  const ToDoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateToAddPage,
      required this.deleteById});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
            onSelected: (value) {
              if (value == 'edit') {
                navigateToAddPage(item);
              } else if (value == 'delete') {
                deleteById(id);
              }
            },
            itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete'))
                ]),
      ),
    );
  }
}

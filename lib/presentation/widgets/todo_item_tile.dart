import 'package:flutter/material.dart';
import 'package:template/domain/entities/todo.dart';

class TodoItemTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onOpen; // 👈 new: tap to open detail
  const TodoItemTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onOpen,
  });


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onOpen, // 👈 navigate to detail when tapped
      leading: Checkbox(value: todo.isDone, onChanged: (_) => onToggle()),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: (todo.note?.isNotEmpty ?? false) ? Text(todo.note!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
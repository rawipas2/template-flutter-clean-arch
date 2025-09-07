import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/presentation/pages/todo_detail_page.dart';

import '../providers/todo_providers.dart';
import '../widgets/todo_editor_dialog.dart';
import '../widgets/todo_item_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});


  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<(String,String)?>(
      context: context,
      builder: (_) => const TodoEditorDialog(titleText: 'New Todo', actionText: 'Add'),
    );
    if (result != null) {
      await ref.read(todoControllerProvider.notifier).add(result.$1, note: result.$2);
    }
  }


  Future<void> _edit(BuildContext context, WidgetRef ref, todo) async {
    final result = await showDialog<(String,String)?>(
      context: context,
      builder: (_) => TodoEditorDialog(
        titleText: 'Edit Todo',
        actionText: 'Save',
        initialTitle: todo.title,
        initialNote: todo.note,
      ),
    );
    if (result != null) {
      await ref.read(todoControllerProvider.notifier).updateTodo(todo, title: result.$1, note: result.$2);
    }
  }


  void _openDetail(BuildContext context, String todoId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TodoDetailPage(todoId: todoId),
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoControllerProvider);


    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: todos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No items'))
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final t = items[i];
            return TodoItemTile(
              todo: t,
              onToggle: () => ref.read(todoControllerProvider.notifier).toggle(t),
              onEdit: () => _edit(context, ref, t),
              onDelete: () => ref.read(todoControllerProvider.notifier).remove(t.id),
              onOpen: () => _openDetail(context, t.id), // 👈 navigate
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
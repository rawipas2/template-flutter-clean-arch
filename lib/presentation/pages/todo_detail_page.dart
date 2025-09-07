import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/domain/entities/todo.dart';
import 'package:template/presentation/widgets/todo_editor_dialog.dart';

import '../providers/todo_providers.dart';

class TodoDetailPage extends ConsumerWidget {
  final String todoId;

  const TodoDetailPage({super.key, required this.todoId});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoControllerProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Todo Detail')),
        body: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (items) {
              final list = items.where((e) => e.id == todoId).toList();
              if (list.isEmpty) {
                return const Center(child: Text('Item not found'));
              }
              final Todo t = list.first;
              return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: t.isDone,
                            onChanged: (_) =>
                                ref
                                    .read(todoControllerProvider.notifier)
                                    .toggle(t),
                          ),
                          Expanded(
                            child: Text(
                              t.title,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if ((t.note?.isNotEmpty ?? false))
                        Text(t.note!),
                      const Divider(height: 32),
                      Text('Created: ${t.createdAt.toLocal()}'),
                      Text('Updated: ${t.updatedAt.toLocal()}'),
                      const Spacer(),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              final result = await showDialog<
                                  (String, String)?>(
                                context: context,
                                builder: (_) =>
                                    TodoEditorDialog(
                                      titleText: 'Edit Todo',
                                      actionText: 'Save',
                                      initialTitle: t.title,
                                      initialNote: t.note,
                                    ),
                              );
                              if (result != null) {
                                await ref.read(todoControllerProvider.notifier)
                                    .updateTodo(
                                    t, title: result.$1, note: result.$2);
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(todoControllerProvider.notifier)
                                  .remove(t.id);
                              if (context.mounted) Navigator.pop(context);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  )
              );
            }
        )
    );
  }
}
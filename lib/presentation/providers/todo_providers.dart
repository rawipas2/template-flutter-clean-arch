// Infrastructure
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/core/result.dart';
import 'package:template/data/datasources/local/todo_local_data_source.dart';
import 'package:template/data/repositories/todo_repository_impl.dart';
import 'package:template/domain/entities/todo.dart';
import 'package:template/domain/usecases/add_todo.dart';
import 'package:template/domain/usecases/delete_todo.dart';
import 'package:template/domain/usecases/get_todos.dart';
import 'package:template/domain/usecases/toggle_complete.dart';
import 'package:template/domain/usecases/update_todo.dart';
import 'package:uuid/uuid.dart';

final localDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  return TodoLocalDataSourceImpl();
});


final repoProvider = Provider((ref) {
  final local = ref.watch(localDataSourceProvider);
  return TodoRepositoryImpl(local);
});


// Use cases
final getTodosProvider = Provider((ref) => GetTodos(ref.watch(repoProvider)));
final addTodoProvider = Provider((ref) => AddTodo(ref.watch(repoProvider)));
final updateTodoProvider = Provider((ref) => UpdateTodo(ref.watch(repoProvider)));
final deleteTodoProvider = Provider((ref) => DeleteTodo(ref.watch(repoProvider)));
final toggleCompleteProvider = Provider((ref) => const ToggleComplete());


// State
class TodoController extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    final r = await ref.read(getTodosProvider).call();
    if (r is Ok<List<Todo>>) return r.value..sort((a,b)=>b.createdAt.compareTo(a.createdAt));
    return [];
  }

  Future<void> refreshList() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }

  Future<void> add(String title, {String? note}) async {
    final now = DateTime.now();
    final todo = Todo(
      id: const Uuid().v4(),
      title: title.trim(),
      note: note?.trim(),
      isDone: false,
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(addTodoProvider).call(todo);
    await refreshList();
  }

  Future<void> toggle(Todo t) async {
    final toggled = ref.read(toggleCompleteProvider).call(t);
    await ref.read(updateTodoProvider).call(toggled);
    await refreshList();
  }

  Future<void> updateTodo(Todo t, {required String title, String? note}) async {
    final updated = t.copyWith(title: title.trim(), note: (note??'').trim(), updatedAt: DateTime.now());
    await ref.read(updateTodoProvider).call(updated);
    await refreshList();
  }

  Future<void> remove(String id) async {
    await ref.read(deleteTodoProvider).call(id);
    await refreshList();
  }
}

final todoControllerProvider = AsyncNotifierProvider<TodoController, List<Todo>>(() => TodoController());
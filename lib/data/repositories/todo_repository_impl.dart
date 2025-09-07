import 'package:template/core/result.dart';
import 'package:template/data/datasources/local/todo_local_data_source.dart';
import 'package:template/data/models/todo_model.dart';
import 'package:template/domain/entities/todo.dart';
import 'package:template/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource local;
  const TodoRepositoryImpl(this.local);


  Future<List<Todo>> _readAll() async {
    final r = await local.getAll();
    if (r is Ok<List<TodoModel>>) {
      return r.value.map((e) => e.toEntity()).toList();
    }
    return [];
  }


  Future<void> _writeAll(List<Todo> items) async {
    final models = items.map(TodoModel.fromEntity).toList();
    await local.saveAll(models);
  }


  @override
  Future<Result<List<Todo>>> getTodos() async => Ok(await _readAll());


  @override
  Future<Result<void>> addTodo(Todo todo) async {
    final items = await _readAll();
    await _writeAll([...items, todo]);
    return const Ok(null);
  }


  @override
  Future<Result<void>> updateTodo(Todo todo) async {
    final items = await _readAll();
    final updated = [
      for (final t in items) if (t.id == todo.id) todo else t,
    ];
    await _writeAll(updated);
    return const Ok(null);
  }


  @override
  Future<Result<void>> deleteTodo(String id) async {
    final items = await _readAll();
    await _writeAll(items.where((t) => t.id != id).toList());
    return const Ok(null);
  }
}
import 'package:template/core/result.dart';
import 'package:template/domain/entities/todo.dart';
import 'package:template/domain/repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repo;
  const UpdateTodo(this.repo);
  Future<Result<void>> call(Todo todo) => repo.updateTodo(todo);
}
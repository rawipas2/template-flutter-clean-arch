import 'package:template/core/result.dart';
import 'package:template/domain/entities/todo.dart';
import 'package:template/domain/repositories/todo_repository.dart';

class AddTodo {
  final TodoRepository repo;
  const AddTodo(this.repo);
  Future<Result<void>> call(Todo todo) => repo.addTodo(todo);
}
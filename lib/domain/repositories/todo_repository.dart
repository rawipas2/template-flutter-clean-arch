import 'package:template/core/result.dart';
import 'package:template/domain/entities/todo.dart';

abstract interface class TodoRepository {
  Future<Result<List<Todo>>> getTodos();
  Future<Result<void>> addTodo(Todo todo);
  Future<Result<void>> updateTodo(Todo todo);
  Future<Result<void>> deleteTodo(String id);
}
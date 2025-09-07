import 'package:template/core/result.dart';
import 'package:template/domain/entities/todo.dart';
import 'package:template/domain/repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repo;
  const GetTodos(this.repo);
  Future<Result<List<Todo>>> call() => repo.getTodos();
}
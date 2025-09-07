import 'package:template/core/result.dart';
import 'package:template/domain/repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repo;
  const DeleteTodo(this.repo);
  Future<Result<void>> call(String id) => repo.deleteTodo(id);
}
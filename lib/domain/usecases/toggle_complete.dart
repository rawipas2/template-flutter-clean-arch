import 'package:template/domain/entities/todo.dart';

class ToggleComplete {
  const ToggleComplete();
  Todo call(Todo t) => t.copyWith(isDone: !t.isDone, updatedAt: DateTime.now());
}
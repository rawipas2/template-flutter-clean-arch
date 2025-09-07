import 'package:template/domain/entities/todo.dart';

class TodoModel {
  final String id;
  final String title;
  final String? note;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;


  const TodoModel({
    required this.id,
    required this.title,
    this.note,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });


  factory TodoModel.fromEntity(Todo e) => TodoModel(
    id: e.id,
    title: e.title,
    note: e.note,
    isDone: e.isDone,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );


  Todo toEntity() => Todo(
    id: id,
    title: title,
    note: note,
    isDone: isDone,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );


  factory TodoModel.fromJson(Map<String, dynamic> j) => TodoModel(
    id: j['id'] as String,
    title: j['title'] as String,
    note: j['note'] as String?,
    isDone: j['isDone'] as bool? ?? false,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );


  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'isDone': isDone,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
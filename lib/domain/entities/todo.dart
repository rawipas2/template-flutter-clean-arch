class Todo {
  final String id;
  final String title;
  final String? note;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;


  const Todo({
    required this.id,
    required this.title,
    this.note,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });


  Todo copyWith({
    String? title,
    String? note,
    bool? isDone,
    DateTime? updatedAt,
  }) => Todo(
    id: id,
    title: title ?? this.title,
    note: note ?? this.note,
    isDone: isDone ?? this.isDone,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
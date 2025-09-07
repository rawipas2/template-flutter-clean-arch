import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/failure.dart';
import 'package:template/core/result.dart';
import 'package:template/data/models/todo_model.dart';

abstract interface class TodoLocalDataSource {
  Future<Result<List<TodoModel>>> getAll();
  Future<Result<void>> saveAll(List<TodoModel> items);
}


class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  static const _key = 'todos_v1';


  @override
  Future<Result<List<TodoModel>>> getAll() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString(_key);
      if (raw == null) return const Ok([]);
      final list = (jsonDecode(raw) as List)
          .map((e) => TodoModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return Ok(list);
    } catch (e) {
      return Err(CacheFailure('read error: $e'));
    }
  }


  @override
  Future<Result<void>> saveAll(List<TodoModel> items) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = jsonEncode(items.map((e) => e.toJson()).toList());
      await sp.setString(_key, raw);
      return const Ok(null);
    } catch (e) {
      return Err(CacheFailure('write error: $e'));
    }
  }
}
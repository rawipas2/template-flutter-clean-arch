# Flutter Clean Architecture + Riverpod — Todo CRUD

---

## 1) โครงสร้างโปรเจกต์ (ย่อ)

```text
lib/
├─ core/                     # โค้ดช่วยรวมกลาง
│  ├─ failure.dart
│  └─ result.dart
├─ domain/                   # กติกาธุรกิจ (ไม่พึ่งพา Flutter)
│  ├─ entities/todo.dart
│  ├─ repositories/todo_repository.dart
│  └─ usecases/
│     ├─ get_todos.dart
│     ├─ add_todo.dart
│     ├─ update_todo.dart
│     ├─ delete_todo.dart
│     └─ toggle_complete.dart
├─ data/                     # คุยกับแหล่งข้อมูลจริง
│  ├─ models/todo_model.dart
│  ├─ datasources/local/todo_local_data_source.dart
│  └─ repositories/todo_repository_impl.dart
├─ presentation/             # UI + State (Riverpod)
│  ├─ pages/
│  │  ├─ home_page.dart
│  │  └─ todo_detail_page.dart
│  ├─ providers/todo_providers.dart
│  └─ widgets/
│     ├─ todo_item_tile.dart
│     └─ todo_editor_dialog.dart
└─ main.dart
```

> **หมายเหตุ:** ใช้ชื่อเมธอดแก้ไขว่า `update_todo.dart` / `updateTodo(...)` เพื่อเลี่ยงชนกับ `AsyncNotifierBase.update(...)`.

---

## 2) ไลบรารีที่ใช้ (พร้อมบทบาท)

- `flutter_riverpod` — จัดการสถานะ/DI (`Provider`, `AsyncNotifier`, `AsyncValue`)
- `shared_preferences` — เก็บ Todo เป็น JSON แบบ local key–value
- `uuid` — สร้างค่า id ให้ Todo (เช่น v4)  
  *แนะนำเสริมตามโครงการ:* `go_router` สำหรับ routing, `isar`/`hive` หากต้องการฐานข้อมูลโลคัลแบบจริงจัง

---

## 3) Workflow / การ delegate ระหว่างไฟล์

### UI → Controller (Riverpod)
- `home_page.dart` แสดงรายการ/ปุ่มเพิ่ม และส่งอีเวนต์ *(add/toggle/edit/delete/open)*
- แตะรายการ → `Navigator.push(...)` ไป `todo_detail_page.dart`
- `todo_item_tile.dart` รวมปุ่มย่อย แล้ว delegate การกระทำผ่าน callback กลับไปให้ `HomePage`

### Controller → Use Cases
- `todo_providers.dart` : ประกาศ `todoControllerProvider` (`AsyncNotifier<List<Todo>>`)
- เมธอดใน `TodoController`
   - `build()` → โหลดรายการด้วย **GetTodos**
   - `add()` → **AddTodo** แล้ว `refreshList()`
   - `updateTodo()` → **UpdateTodo** แล้ว `refreshList()`
   - `toggle()` → **ToggleComplete** → **UpdateTodo** แล้ว `refreshList()`
   - `remove()` → **DeleteTodo** แล้ว `refreshList()`

### Use Cases → Repository (Interface)
- `domain/repositories/todo_repository.dart` : สัญญา `get/add/update/delete`
- `usecases/*.dart` เรียกผ่าน interface เพื่อลดการพึ่งพา implementation

### Repository Impl → Data Source → Storage
- `data/repositories/todo_repository_impl.dart` แปลง `Todo ⇄ TodoModel` แล้วเรียก data source
- `data/datasources/local/todo_local_data_source.dart` อ่าน/เขียน key `'todos_v1'` ด้วย **SharedPreferences** (เก็บเป็น JSON list)

### Core ช่วยจัดรูปแบบผลลัพธ์/ข้อผิดพลาด
- `core/result.dart` : โครงสร้าง `Ok/Err`
- `core/failure.dart` : ประเภทข้อผิดพลาด (เช่น `CacheFailure`)

### Navigation (หลายหน้า)
- `HomePage` → *(แตะรายการ)* → `TodoDetailPage(todo)`
- ใน `TodoDetailPage` เรียก `todoControllerProvider.notifier` เพื่อ `update/toggle/remove` ได้โดยตรง แล้ว `pop()` กลับมา รายการจะอัปเดตเอง

---

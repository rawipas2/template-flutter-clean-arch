import 'package:flutter/material.dart';

class TodoEditorDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialNote;
  final String titleText; // dialog title
  final String actionText; // button text
  const TodoEditorDialog({super.key, this.initialTitle, this.initialNote, required this.titleText, required this.actionText});


  @override
  State<TodoEditorDialog> createState() => _TodoEditorDialogState();
}


class _TodoEditorDialogState extends State<TodoEditorDialog> {
  late final TextEditingController titleCtrl;
  late final TextEditingController noteCtrl;


  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    noteCtrl = TextEditingController(text: widget.initialNote ?? '');
  }


  @override
  void dispose() {
    titleCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Note')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, (titleCtrl.text, noteCtrl.text)), child: Text(widget.actionText)),
      ],
    );
  }
}
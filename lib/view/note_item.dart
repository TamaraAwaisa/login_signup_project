import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_notes_project/model/note_model.dart';

class NoteItem extends StatelessWidget {
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedDelete;
  final NoteModel noteModel;
  const NoteItem({super.key, required this.noteModel, required this.onPressedEdit, required this.onPressedDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(noteModel.msg),
        Row(children: [
          IconButton(onPressed: onPressedDelete, icon: Icon(Icons.delete)),
          IconButton(onPressed: onPressedEdit, icon: Icon(Icons.edit))
        ],
        ),
      ],
    );
  }
}

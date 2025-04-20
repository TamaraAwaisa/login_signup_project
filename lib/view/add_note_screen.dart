import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_notes_project/controller/db_controller.dart';

class AddNoteScreen extends StatelessWidget {

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: textEditingController,
          decoration: InputDecoration(
            label: Text("Note"),
            hintText: "Type something ..",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2))
                ),
              ),
        ),
    ),
      bottomNavigationBar: TextButton(
          onPressed: ()async{
            await DbController().insertNote(msg: textEditingController.text);
            Navigator.pop(context);
          }, child: Text("Save")),
    );
  }
}

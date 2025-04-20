import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_notes_project/view/update_note_screen.dart';
import '../controller/db_controller.dart';
import '../model/note_model.dart';
import 'add_note_screen.dart';
import 'note_item.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  List<NoteModel> notes = [];
  DbController dbController = DbController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    notes = await dbController.getNotes();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return NoteItem(noteModel: notes[index],
          onPressedDelete: ()async{
            await dbController.deleteNote(id: notes[index].id);
            getData();
            setState(() {});
          },
          onPressedEdit: ()async{
            await Navigator.push(context,
                MaterialPageRoute(builder: (context)=>UpdateNoteScreen(noteModel: notes[index],))

            );
            getData();
            setState(() {});
          },


          );

        },
        itemCount: notes.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>AddNoteScreen()),
          );
          getData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
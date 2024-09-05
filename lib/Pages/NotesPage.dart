import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_app/models/NoteItem.dart';
import '../boxes.dart';
import '../models/Note.dart';
import 'NewNote.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, Key? ankey});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewNote(),
                ),
              ).then((data) {
                setState(() {

                });
              });

            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: noteBox.length,
        itemBuilder: (context, index) {
          final note = noteBox.getAt(index) as Note;
          return InkWell(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewNote(initialDate: DateFormat('dd.MM.yyyy').format(note.date!).toString(), initialNoteName: note.noteName!, initialText: note.text!,),
                ),
              ).then((data) {
                setState(() {

                });
              });
            },
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                final removedNote = noteBox.getAt(index) as Note; // Сохраняем удаляемый элемент
                setState(() {
                  noteBox.deleteAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Заметка удалена'),
                    action: SnackBarAction(
                      label: 'Отмена',
                      onPressed: () {
                        setState(() {
                          noteBox.add(removedNote); // Восстанавливаем удаленный элемент
                        });
                      },
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: NoteItem(note: note),
                ),
              ),
            ),
          );
        },

      ),
    );
  }
}

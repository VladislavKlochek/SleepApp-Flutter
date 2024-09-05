import 'package:flutter/material.dart';
import 'Note.dart';
import 'package:intl/intl.dart';

class NoteItem extends StatefulWidget {
  final Note note;

  const NoteItem({super.key, required this.note});

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    final Note note = widget.note;


    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          gradient: LinearGradient(colors:[Color.fromARGB(228, 91, 75, 125), Color.fromARGB(
            211, 111, 80, 125)])
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateFormat('dd.MM.yyyy').format(note.date!),
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'avenir',
                    color: Colors.white
                  ),
                ),
                Text(
                  note.noteName!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Gost Type B',
                      color: Colors.white
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    note.text!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "avenir",
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines:
                        6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleep_app/models/Note.dart';
import '../boxes.dart';

class NewNote extends StatefulWidget {
  final String initialDate;
  final String initialNoteName;
  final String initialText;

  const NewNote(
      {super.key, this.initialDate = '',
      this.initialNoteName = '',
      this.initialText = ''});

  @override
  _NewNote createState() => _NewNote();
}

class _NewNote extends State<NewNote> {
  late TextEditingController _nameController;
  late TextEditingController _textController;
  final _focusNode = FocusNode();
  bool isReadOnly = true;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate != ''
        ? DateFormat('dd.MM.yyyy').parse(widget.initialDate)
        : DateTime.now();
    _nameController = TextEditingController(text: widget.initialNoteName);
    _textController = TextEditingController(text: widget.initialText);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _textController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        isReadOnly = false;
        FocusScope.of(context).requestFocus(_focusNode);
      });
    } else {
      setState(() {
        isReadOnly = true;
      });
    }
  }

  void _openDatePicker() {
    FocusScope.of(context).unfocus();
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  DateFormat('dd.MM.yyyy').format(_selectedDate),
                  style: const TextStyle(fontSize: 25),
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: _nameController,
                    readOnly: isReadOnly,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      // Background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none, // No border
                      ),
                      hintText: 'Название',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200], // Background color
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // No border
                    ),
                    hintText: 'Enter text here',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: const Color.fromARGB(222, 87, 8, 121),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      if (widget.initialText != '') {
                        var n = Note(
                            date: _selectedDate,
                            noteName: _nameController.text,
                            text: _textController.text);
                        noteBox.putAt(
                            noteBox.values.toList().indexWhere((note) =>
                                note.noteName == widget.initialNoteName),
                            n);
                      } else {
                        var n = Note(
                            date: _selectedDate,
                            noteName: _nameController.text,
                            text: _textController.text);
                        noteBox.put(n.text, n);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50, // Adjust the height as needed
                      width: 200, // Adjust the width as needed
                      alignment: Alignment.center,
                      child: const Text(
                        "Готово",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: const Color.fromARGB(211, 71, 48, 82),
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          _openDatePicker();
                        },
                        child: Container(
                          height: 50, // Adjust the height as needed
                          width: 150, // Adjust the width as needed
                          alignment: Alignment.center,
                          child: const Text(
                            "Дата",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: const Color.fromARGB(211, 71, 48, 82),
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          _focusNode.requestFocus();
                          _nameController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _nameController.value.text.length));
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          alignment: Alignment.center,
                          child: const Text(
                            "Название",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

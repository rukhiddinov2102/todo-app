import 'package:flutter/material.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/note_model.dart';
import 'package:intl/intl.dart';
import 'package:todo/screens/home_scree.dart';


class AddNoteScreen extends StatefulWidget {
  final Note? note;
  final Function? upadateNoteList;

  const AddNoteScreen({Key? key, this.note, this.upadateNoteList}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _datecontroller = TextEditingController();

  late var _date = DateTime.now();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  String _priority = 'Low';

  String _title = "";

  String btnText = 'Add Note';

  String titleText = 'Add Note';

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _datecontroller.text = _dateFormatter.format(date);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      _priority = widget.note!.priority!;

      setState(() {
        btnText = 'Update Note';
        titleText = 'Update Note';
      });
    } else {
      setState(() {
        btnText = 'Add Note';
        titleText = 'Add Note';
      });
    }

    _datecontroller.text = _dateFormatter.format(_date);

    widget.upadateNoteList!;
  }

  @override
  void dispose() {
    super.dispose();
    _datecontroller.dispose();
    widget.upadateNoteList!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    titleText,
                    style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: "Title",
                              labelStyle: const TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (input) => input!.trim().isEmpty
                                ? 'Please enter the title'
                                : null,
                            onSaved: (input) => _title = input!,
                            initialValue: _title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          child: TextFormField(
                            style: const TextStyle(fontSize: 18.0),
                            onTap: _handleDatePicker,
                            readOnly: true,
                            controller: _datecontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: "Date",
                                labelStyle: const TextStyle(fontSize: 18.0)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: DropdownButtonFormField(
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 22.0,
                            iconEnabledColor: Theme.of(context).primaryColor,
                            items: _priorities.map((String priority) {
                              return DropdownMenuItem(
                                  value: priority,
                                  child: Text(
                                    priority,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ));
                            }).toList(),
                            decoration: InputDecoration(
                                labelText: "Priority",
                                labelStyle: const TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            value: _priority,
                            onChanged: (val) {
                              setState(() {
                                _priority = val.toString();
                              });
                            },
                            // ignore: unnecessary_null_comparison
                            validator: (input) => _priority == null
                                ? 'Please select priority level'
                                : null,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            child: Text(btnText),
                            onPressed: () => _submit(),
                          ),
                        ),
                        widget.note != null
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20,vertical: 20.0),
                                height: 60.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(primary:Colors.red),
                                  child: const Text(
                                    "Delete Note",
                                    style: TextStyle(
                                        color: Colors.white,),
                                  ),
                                  onPressed: _delete,
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('$_title, $_date, $_priority');

      Note note = Note(title: _title, date: _date, priority: _priority);

      if (widget.note == null) {
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);
        debugPrint(note.status.toString());

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
      } else {
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);
        debugPrint(note.status.toString());

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
      }

      widget.upadateNoteList!();
    }
  }

  _delete() {
    setState(() {
      DatabaseHelper.instance.deleteNote(widget.note!.id!);
      widget.upadateNoteList!;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
    });
  }
}

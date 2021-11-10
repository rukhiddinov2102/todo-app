import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todo/database/database.dart';
import 'package:todo/models/note_model.dart';
import 'package:todo/screens/addnote_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   Future<List<Note>>? _noteList;

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  final _databaseHelper = DatabaseHelper.instance;


  @override
  void initState() {
    super.initState();
    setState(() {
      _updateNoteList();
    });
    
  }

  _updateNoteList() {
    _noteList = _databaseHelper.getNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) =>  AddNoteScreen(
                upadateNoteList: _updateNoteList,
              )));
        },
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      
            final int completeNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;
      
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: int.parse(snapshot.data.length.toString()) + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Column(
                      children: [
                        const Text("Your Tasks",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 22),),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "$completeNoteCount of ${snapshot.data.length}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                return _buildNote(snapshot.data![index-1]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNote(Note note) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: ListTile(
            title: Text(
              note.title!,
              style: TextStyle(
                  fontSize: 18.0,
                  color: note.status == 1 ? Colors.green : Colors.black,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              "${_dateFormat.format(note.date!)} - ${note.priority}",
              style: TextStyle(
                  fontSize: 15.0,
                  color: note.status == 1 ? Colors.green : Colors.black,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (val) {
               setState(() {
                  note.status = val! ? 1 : 0;
                DatabaseHelper.instance.updateNote(note);
                _updateNoteList();
               });
              },
              activeColor: Colors.green,
              value: note.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  AddNoteScreen(
                note: note,
                upadateNoteList: _updateNoteList,
              )),
            ),
          ),
        ),
      ],
    );
  }
}

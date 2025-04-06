// import 'dart:convert';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notev2/home.dart';
import 'package:notev2/notemodel.dart';
import 'package:notev2/notemodel.dart';
import 'package:sqflite/sqflite.dart';

import 'notemodel.dart';

class Detail extends StatefulWidget {
  Detail({
    super.key,
    required this.title,
    required this.id,
    required this.detail,
  });
  final int id;
  final String title;
  final String detail;
  @override
  State<Detail> createState() => _DetailState();
}

List<NoteModel> detailist = [];

class _DetailState extends State<Detail> {
  Future store() async {
    // ignore: collection_methods_unrelated_type

    print("detail success");

    detailist = await db.getNotemodelbyid(widget.id);
    setState(() {});
    print("detailist>>>>>>${detailist[0]}");

    // var N = database().n;
    print("nnnnnnnn>>>");
    // print('listview>>>${ak[widget.id]['detail']}');
  }

  @override
  void initState() {
    store();
    super.initState();
  }

  database _db = database();
  Future appendToValue(int id, String newValue) async {
    // Fetch the current value
    String existingValue = await _db
        .updateNote(NoteModel(id: id, title: '', detail: _detail.text))
        .toString();
    print("existing value!!!!==$existingValue");
    // Append new data to the existing value
    String updatedValue = existingValue + newValue;
    print("update value==$updatedValue");
    Future updateNote(NoteModel note) async {
      Database? data;
      // Convert the NoteModel to a Map
      Map<String, dynamic> noteMap = note.toMap();
      final n = await data!.update(
        'note',
        noteMap, // Data to be updated
        where: 'id = ?', // Condition to specify the row
        whereArgs: [note.id],
      );
      print("mmmmannanam$n");
    }

    print("update>>>>>>>>>");
    // Update the database
    // final db = await database;
  }

  TextEditingController _detail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.black,
          elevation: BorderSide.strokeAlignOutside,
          tooltip: 'save',
          focusColor: Colors.black,
          child: Icon(Icons.save),
          backgroundColor: Colors.blue,
          onPressed: () async {
            // int id = Random().nextInt(1000);

            await db.updateNote(NoteModel(
                id: widget.id, title: widget.title, detail: _detail.text));
            appendToValue(widget.id, _detail.text);
            store();

            // store();
            // print('id>>>>${''}');
          }),
      body: detailist.isEmpty
          ? Container()
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // White
                    Color(0xFF0F2027), // Dark Blue (Outer Space)
                    Color(0xFF2C5364), // Deep Sea Blue
                    Color(0xFF4CA1AF), //
                  ],
                  begin: Alignment.topLeft, // Gradient start point
                  end: Alignment.bottomRight, // Gradient end point
                ),
              ),
              child: Center(
                // scrollDirection: Axis.vertical,
                //
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(70),
                                topRight: Radius.circular(80)),
                            gradient: LinearGradient(
                              colors: [
                                // White
                                Color.fromARGB(255, 137, 187, 228),
                                Colors.blue,

                                // Colors.white // Dark Blue (Outer Space)
                              ],
                              begin: Alignment
                                  .bottomCenter, // Gradient start point
                              end: Alignment.topCenter, // Gradient end point
                            ),
                          ),
                          // margin: EdgeInsets.only(top: 50),
                          // color: Colors.white,
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: _detail,
                            maxLines: 4,
                            // expands: true,
                            decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(34))),
                              hintText: "INSERT YOUR NOTE",
                            ),

                            scrollPadding: const EdgeInsets.all(60.0),
                            keyboardType: TextInputType.multiline,
                            // maxLines: 99,
                            // autofocus: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            width: double.infinity,
                            height: 400,
                            decoration: const BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              gradient: LinearGradient(
                                colors: [
                                  // White
                                  Color.fromARGB(255, 137, 187, 228),
                                  Colors.blue,

                                  // Colors.white // Dark Blue (Outer Space)
                                ],
                                begin: Alignment
                                    .bottomCenter, // Gradient start point
                                end: Alignment.topCenter, // Gradient end point
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                detailist[0].detail,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily:
                                      'PlaywriteGBS-Italic-VariableFont_wght',
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              appendToValue(widget.id, _detail.text);
                            },
                            child: Text('ddd'))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class detail {
  String details = '';
  int id;
  detail({
    required this.details,
    required this.id,
  });
  factory detail.fromJson(Map<String, dynamic> json) =>
      detail(details: json['details'], id: json['id']);
}

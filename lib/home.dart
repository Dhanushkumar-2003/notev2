import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notev2/detail.dart';
import 'package:notev2/notemodel.dart';
import 'package:notev2/search.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final TextEditingController _controller1 = TextEditingController();
database db = database();
List ak = [];
List stores = [];

@override
@override
class _HomeState extends State<Home> {
  @override
  void initState() {
    print('nmnnnnnn');
    store();
    // filteredTitles = ak;
    super.initState();
  }

  Future store() async {
    ak = await db.getTasks();
    print("store succfgjfess");
    print("store>>>>>>>$ak");
    setState(() {
      stores = ak;
    });

    // print("store>>>>>>>$stores");
  }

  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();
  List filteredTitles = [];
  bool aa = false;
  String searchText = "";
  void _filterTitles(searchTerm) {
    aa = true;
    setState(() {
      print("dkk>>>>");
      filteredTitles = ak
          .where((title) =>
              title['title'].toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
      print('nnnnnnnnnnnnnn$searchText');
    });
    print("serch>>>>>>>>>${filteredTitles}");
  }

  String filterPrice = '';
  List filteredProducts = [];
  void filterProductsByPrice(String price) {
    setState(() {
      filterPrice = price;
      // Use the 'where' method to filter products by price
      filteredProducts = ak
          // ignore: avoid_types_as_parameter_names
          .where((NoteModel) => NoteModel.contains(filterPrice))
          .toList();
    });
    print("filerterr>>>>$filteredProducts");
  }

  Widget showlist() {
    return Expanded(
      child: Container(
        child: Expanded(
          child: ListView.builder(
              itemCount: ak.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(ak[index]['title']),
                  direction:
                      DismissDirection.endToStart, // Swipe from right to left
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    print('DISIMISIBLE');
                    // Remove the item from the list
                    (() async {
                      await db.deleteRecord(ak[index]['id']);
                      ak.removeAt(index);
                      final NN = db.deleteRecord(ak[index]['id']);
                      print("NNNNNNNNNNNNNNNNNNNN$NN");
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 40),
                    margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
                    // height: 300,
                    // width: 40,
                    height: 120,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            // White
                            Color.fromARGB(255, 137, 187, 228),
                            Colors.blue,

                            // Colors.white // Dark Blue (Outer Space)
                          ],
                          begin: Alignment.bottomCenter, // Gradient start point
                          end: Alignment.topCenter, // Gradient end point
                        ),

                        // borderRadius:
                        //     BorderRadius.horizontal(
                        //       right: Radius.circular(40),),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(80),
                            bottomRight: Radius.circular(80)),
                        border: Border(
                            top: BorderSide(width: 2),
                            left: BorderSide(width: 2),
                            right: BorderSide(width: 2),
                            bottom: BorderSide(width: 2))),
                    child: Center(
                        child: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  // ignore: prefer_const_constructors
                                  builder: (context) => Detail(
                                      id: ak[index]['id'],
                                      detail: ak[index]['detail'],
                                      title: ak[index]['title'])));
                            },
                            child: Center(
                              child: Text(
                                "${ak[index]['title']}",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            )),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       setState(() {
                        //         filterProductsByPrice(
                        //             ak[index]['title']);
                        //       });
                        //     },
                        //     child: Text("delete")),
                        // for (var product in filteredProducts)
                        //   _buildProductCard(product, context),
                      ],
                    )),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return SizedBox(
      height: 45,

      // width: 360,
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: const Color(0xff020202),
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          // disabledBorder: ,
          filled: true,
          fillColor: const Color(0xfff1f1f1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          hintText: "Search for Items",
          hintStyle: TextStyle(
              color: const Color(0xffb2b2b2),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              decorationThickness: 6),
        ),
        onChanged: (value) {
          _filterTitles(value);
          // ignore: avoid_print

          // Filter titles as user types
        },
      ),
    );
  }

  double _containerHeight = 100.0;

  void _updateContainerSize() {
    setState(() {
      // Parse user input and update the container size
      _containerHeight = double.tryParse(_controller1.text) ?? 400.0;
    });
  }

  bool myBool = false;
  bool _searchBoolean = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 5,
            title: !_searchBoolean
                ? Center(
                    child: Text(
                    "note",
                    style: TextStyle(
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'PlaywriteGBS-Italic-VariableFont_wght'),
                  ))
                : _searchTextField(),
            actions: _searchBoolean == false
                ? [
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = true;
                          });
                        })
                  ]
                : [
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          store();
                          setState(() {});
                          _searchBoolean = false;
                          aa = false;
                        })
                  ]),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // begin: Alignment.topCenter,
              // end: Alignment.topLeft,
              colors: [
                Colors.cyan,
                Colors.white,
                // Colors.blue
                // Color(0xFF0d1b2a), // Dark Blue / Navy
                // Color(0xFF3b185f), // Purple
                // Color(0xFF2a043d), // Dark Violet
                // Color(0xFF000000), // Black
                // Color(0xFF00d4ff), // Cyan / Teal
              ],
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ignore: unrelated_type_equality_checks
                // _searchTextField(),
                aa == false
                    ? Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(11),
                                topRight: Radius.circular(10)),
                          ),

                          // color: Colors.white,
                          // width: 300,
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _controller1,
                            maxLines: 2,
                            autofocus: false,
                            decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                hintText: 'ENTER TITLE',

                                // pr
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      int id = Random().nextInt(100);

                                      if (_controller1.text != "") {
                                        await db.insert(NoteModel(
                                            id: id,
                                            title: _controller1.text,
                                            detail: ''));
                                        myBool = true;
                                        store();
                                        _controller1.clear();
                                        setState(() {});
                                      } else {
                                        print("emty text");
                                      }
                                    },
                                    icon: Icon(Icons.arrow_forward_ios)),
                                suffixStyle:
                                    const TextStyle(color: Colors.green)),
                          ),
                        ),
                      )
                    : Container(),

                SizedBox(
                  height: 30,
                ),
                // ignore: prefer_cons
                aa == false
                    ? Expanded(
                        child: Container(
                          child: Expanded(
                            child: ListView.builder(
                                itemCount: ak.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              // ignore: prefer_const_constructors
                                              builder: (context) => Detail(
                                                  id: ak[index]['id'],
                                                  detail: ak[index]['detail'],
                                                  title: ak[index]['title'])));
                                    },
                                    child: Dismissible(
                                      key: Key(ak[index]['title']),
                                      direction: DismissDirection
                                          .endToStart, // Swipe from right to left
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      onDismissed: (direction) {
                                        print('DISIMISIBLE');
                                        // Remove the item from the list
                                        setState(() async {
                                          await db
                                              .deleteRecord(ak[index]['id']);
                                          ak.removeAt(index);
                                          final NN =
                                              db.deleteRecord(ak[index]['id']);
                                          print("NNNNNNNNNNNNNNNNNNNN$NN");
                                        });
                                      },
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 100,
                                        ),
                                        padding: EdgeInsets.only(top: 40),
                                        margin: EdgeInsets.only(
                                            bottom: 20, left: 15, right: 15),
                                        // height: 300,
                                        // width: 40,
                                        // height: 120,
                                        // height: _containerHeight,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                // White
                                                Color.fromARGB(
                                                    255, 137, 187, 228),
                                                Colors.blue,

                                                // Colors.white // Dark Blue (Outer Space)
                                              ],
                                              begin: Alignment
                                                  .bottomCenter, // Gradient start point
                                              end: Alignment
                                                  .topCenter, // Gradient end point
                                            ),

                                            // borderRadius:
                                            //     BorderRadius.horizontal(
                                            //       right: Radius.circular(40),),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(80),
                                                    bottomRight:
                                                        Radius.circular(80)),
                                            border: Border(
                                                top: BorderSide(width: 2),
                                                left: BorderSide(width: 2),
                                                right: BorderSide(width: 2),
                                                bottom: BorderSide(width: 2))),
                                        child: Center(
                                            child: Column(
                                          children: [
                                            GestureDetector(
                                                child: Center(
                                              child: Text(
                                                "${ak[index]['title']}",
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily:
                                                        'PlaywriteGBS-Italic-VariableFont_wght',
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            )),
                                            // ElevatedButton(
                                            //     onPressed: () {
                                            //       setState(() {
                                            //         filterProductsByPrice(
                                            //             ak[index]['title']);
                                            //       });
                                            //     },
                                            //     child: Text("delete")),
                                            // for (var product in filteredProducts)
                                            //   _buildProductCard(product, context),
                                          ],
                                        )),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredTitles.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Container(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  padding: EdgeInsets.only(top: 40),
                                  margin: EdgeInsets.only(
                                      bottom: 20, left: 15, right: 15),
                                  height: 200,
                                  // width: 40,
                                  // height: 20,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          // White
                                          Color.fromARGB(255, 137, 187, 228),
                                          Colors.blue,

                                          // Colors.white // Dark Blue (Outer Space)
                                        ],
                                        begin: Alignment
                                            .bottomCenter, // Gradient start point
                                        end: Alignment
                                            .topCenter, // Gradient end point
                                      ),
                                      // borderRadius:
                                      //     BorderRadius.horizontal(
                                      //       right: Radius.circular(40),),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(80),
                                          bottomRight: Radius.circular(80)),
                                      border: Border(
                                          top: BorderSide(width: 2),
                                          left: BorderSide(width: 2),
                                          right: BorderSide(width: 2),
                                          bottom: BorderSide(width: 2))),

                                  child: Center(
                                      child: Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    // ignore: prefer_const_constructors
                                                    builder: (context) =>
                                                        Detail(
                                                            id: ak[index]['id'],
                                                            detail: ak[index]
                                                                ['detail'],
                                                            title: ak[index]
                                                                ['title'])));
                                          },
                                          child: Center(
                                            child: Text(
                                              (filteredTitles[index]['title']),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ],
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class database {
  Map<String, dynamic> n = {};
  Database? _database;

  // DatabaseHelper() {
  //   initDatabase();
  // }

  Future<void> initDatabase() async {
    if (_database != null) return;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'store.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE note(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            detail TEXT
          )
          ''',
        );
      },
      version: 1,
    );
    print("insert successs");
  }

  Future<int?> insert(NoteModel notes) async {
    await initDatabase();
    print("MLM");
    return _database?.insert('note', notes.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // print("INSERT>>>>$k");
  }

  Future<int> updateNote(NoteModel note) async {
    // Convert the NoteModel to a Map
    Map<String, dynamic> noteMap = note.toMap();
    return await _database!.update(
      'note',
      noteMap, // Data to be updated
      where: 'id = ?', // Condition to specify the row
      whereArgs: [note.id],
    );
  }

  Future<List<NoteModel>> getNotemodelbyid(int id) async {
    print("id>>>$id");
    var notelist =
        await _database!.query('note', where: 'id = ?', whereArgs: [id]);
    List<NoteModel> notemodel = notelist.isNotEmpty
        ? notelist.map((c) => NoteModel.fromMap(c)).toList()
        : [];
    print("NOtelist>>>>>>$notelist");
    return notemodel;
  }

  Future<void> deleteRecord(int id) async {
    print("delete");
    final db = await database;
    await _database!.delete(
      'note',
      where: "id = ?",
      whereArgs: [id],
    );

    print('Deleted record with id: $id');
  }

  Future getTasks() async {
    await initDatabase();

    List<Map<String, dynamic>> maps = await _database!.query('note');
    print("MAP>>>>>${maps}");
    return List.generate(maps.length, (i) {
      n = NoteModel(
              id: maps[i]['id'],
              title: maps[i]['title'],
              detail: maps[i]['detail'])
          .toMap();
      print("details collection id ${n['id']}");
      print("details collection title${n['title']}");
      print("details collection detail${n['detail']}");

      return n;
    });
  }
}

Widget _buildProductCard(NoteModel product, BuildContext context) {
  return Card(
    elevation: 5,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          SizedBox(height: 5),
        ],
      ),
    ),
  );
}

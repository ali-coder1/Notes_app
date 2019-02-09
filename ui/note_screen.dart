import 'package:flutter/material.dart';
import 'package:note_app/model/note_item.dart';
import 'package:note_app/util/database_client.dart';
import 'package:note_app/util/date_formatter.dart';

class BodyScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<BodyScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper(); // Called it from database_client
  final List<NoteItem> _itemList = <NoteItem>[]; // store items inside array

  @override
  void initState() {
    super.initState();
    _readNoteList(); //read the note's list from Database
  }

  // Here when user submit to save a new note item
  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    NoteItem _noteItem = NoteItem(text, dateFormatter());
    int savedItemID = await db.saveItem(_noteItem);

    NoteItem _addedItem = await db.getItem(savedItemID);

    setState(() {
      _itemList.insert(0, _addedItem);
    });

    print("Item Saved ID: $savedItemID");
  }

  // Here when user submit to update an old note item
  void _handleSubmittedUpdate(int index, NoteItem item) {
    _textEditingController.clear();
    setState(() {
      _itemList
          .removeWhere((element) => _itemList[index].itemName == item.itemName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: _itemList[index],
                      onLongPress: () =>
                          _updateNoteItem(_itemList[index], index),
                      trailing: Listener(
                        key: Key(_itemList[index].itemName),
                        child:
                            Icon(Icons.remove_circle, color: Colors.redAccent),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoteItem(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "eg. Do my math homework",
                  icon: Icon(Icons.note_add)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              // This step to hide the alert add item window after clicked save
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  // To add the note items that saved inside the database and make it visible
  _readNoteList() async {
    List items = await db.getItems();
    items.forEach((item) {
      // This step to display all saved note items on screen
      setState(() {
        _itemList.add(NoteItem.map(item));
      });

      // NoteItem _noteItem = NoteItem.fromMap(item); // (This step wes for debugging)
      // print("DB Item: ${_noteItem.itemName}"); // (This step wes for debugging)
    });
  }

  // To remove the note items that deleted from the note list and the database as well
  _deleteNoteItem(int id, int index) async {
    debugPrint("Item Deleted!!");
    // This step will remove the item from database
    await db.deleteItem(id);
    // This step to remove the note item from the note screen
    setState(() {
      _itemList.removeAt(index);
    });
  }

  // To update the note items that selected from the note list
  _updateNoteItem(NoteItem item, int index) async {
    var alert = AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "Update your note",
                  icon: Icon(Icons.update)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              NoteItem _newItemUpdated = NoteItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatter(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateItem(_newItemUpdated); //updating the item
              setState(() {
                _readNoteList(); //redrawing the screen with all items saved inside database
              });

              Navigator.pop(context);
            },
            child: Text("Update")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}

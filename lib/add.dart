import "package:flutter/material.dart";
import "database.dart";
import "package:http/http.dart" as http;

class AddEdit extends StatefulWidget {
  Map? map={};
  AddEdit({super.key,this.map});

  @override
  State<AddEdit> createState() => _AddEditState();
}

class _AddEditState extends State<AddEdit> {
  @override
  Widget build(BuildContext context) {
    TextEditingController name=TextEditingController();

    name.text=widget.map?["name"]??"";

    return Scaffold(
      appBar: AppBar(
        title: Text("Add/Update"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          TextFormField(controller: name,decoration: InputDecoration(hintText: "Enter your name")),

          ElevatedButton(onPressed: () {
            widget.map!=null?
            MyDataBase().Update({"name":name.text}, widget.map?["id"]).then((value) {
              Navigator.pop(context);
            }):
            MyDataBase().Post({"name":name.text}).then((value) {
              Navigator.pop(context);
            })
            ;
          }, child: Text(widget.map==null?"Add":"edit")),
        ],
      ),
    );
  }
}
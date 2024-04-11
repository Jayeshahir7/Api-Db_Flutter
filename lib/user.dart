import 'package:flutter/material.dart';
import 'package:pdemo/add.dart';
import 'database.dart';

class user extends StatefulWidget {
  user({super.key});

  @override
  State<user> createState() => _HomeState();
}

class _HomeState extends State<user> {
  @override
  Widget build(BuildContext context) {
    MyDataBase().onInit();
    List display = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("SHOW"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEdit(),
              )).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: MyDataBase().GetAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            display.clear();
            display.addAll(snapshot.data!);

            return ListView.builder(
              itemCount: display.length,
              itemBuilder: (context, index) {
                return Container(

                  child: ListTile(

                    title: Column(
                      children: [
                        Text(display[index]["name"]),
                      ],
                    ),
                    trailing: GestureDetector(
                        onTap: () {
                          MyDataBase()
                              .Delete(display[index]["id"])
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.delete, color: Colors.red)),
                    leading: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEdit(map: {...display[index]}),
                              )).then((value) {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.edit, color: Colors.blue)),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

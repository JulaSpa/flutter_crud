import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_flutter/services/firebase_service.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 29, 52, 70),
          title: Center(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Ajusta la esquina del Card
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, size: 24),
                      hintText: "Search"),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
            ),
          )),
      body: FutureBuilder<List>(
        future: getPeople(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var data = snapshot.data?[index];
                //si el search está vacío
                if (name.isEmpty) {
                  return Dismissible(
                    onDismissed: (direction) async {
                      //recibe un direction pero no lo usamos
                      await deletePeople(snapshot.data?[index]["uid"]);
                      //si bien esto lo elimina de la base de datos no lo elimina del itemCount, osea q da error, para eso usamos setState:
                      snapshot.data?.removeAt(index);
                    }, //funcion q se ejecuta cuando el objeto es eliminado y permite mandarle info al method delete del archivo firebase_service.
                    confirmDismiss: (direction) async {
                      //para confirmar el delete
                      bool result = false;
                      result = await showDialog(
                          //result igual al true o false del showdialog
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "¿Delete ${snapshot.data?[index]['name']}?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(
                                        context,
                                        true,
                                      );
                                    },
                                    child: const Text("Delete"))
                              ],
                            );
                          });
                      return result;
                    },
                    //Desplaza los elementos, requiere una key
                    background: Container(
                      child: const Icon(Icons.delete),
                    ),

                    direction: DismissDirection.endToStart,
                    key: Key(snapshot.data?[index]["uid"]),

                    child: ListTile(
                      title: Text(data["name"]),
                      onTap: (() async {
                        await Navigator.pushNamed(context, "/edit", arguments: {
                          "name": snapshot.data?[index]['name'],
                          "uid": snapshot.data?[index]["uid"],
                        });
                        setState(() {});
                      }),
                    ),
                  );
                  //name == search
                } else if (data["name"]
                    .toString()
                    .startsWith(name.toLowerCase())) {
                  return Dismissible(
                    onDismissed: (direction) async {
                      //recibe un direction pero no lo usamos
                      await deletePeople(snapshot.data?[index]["uid"]);
                      //si bien esto lo elimina de la base de datos no lo elimina del itemCount, osea q da error, para eso usamos setState:
                      snapshot.data?.removeAt(index);
                    }, //funcion q se ejecuta cuando el objeto es eliminado y permite mandarle info al method delete del archivo firebase_service.
                    confirmDismiss: (direction) async {
                      //para confirmar el delete
                      bool result = false;
                      result = await showDialog(
                          //result igual al true o false del showdialog
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "¿Delete ${snapshot.data?[index]['name']}?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(
                                        context,
                                        false,
                                      );
                                    },
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      return Navigator.pop(
                                        context,
                                        true,
                                      );
                                    },
                                    child: const Text("Delete"))
                              ],
                            );
                          });
                      return result;
                    },
                    //Desplaza los elementos, requiere una key
                    background: Container(
                      child: const Icon(Icons.delete),
                    ),

                    direction: DismissDirection.endToStart,
                    key: Key(snapshot.data?[index]["uid"]),

                    child: ListTile(
                      title: Text(data["name"]),
                      onTap: (() async {
                        await Navigator.pushNamed(context, "/edit", arguments: {
                          "name": snapshot.data?[index]['name'],
                          "uid": snapshot.data?[index]["uid"],
                        });
                        setState(() {});
                      }),
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, "/add");
            setState(() {});
          },
          child: const Icon(Icons.add)),
    );
  }
}

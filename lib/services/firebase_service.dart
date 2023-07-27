import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//get method
Future<List> getPeople() async {
  List people = [];
  CollectionReference collectionReferencePeople = db.collection("people");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  for (var element in queryPeople.docs) {
    final Map<String, dynamic> data = element.data() as Map<String, dynamic>;
    final person = {
      "name": data["name"],
      "uid": element.id,
    };
    people.add(person);
  }
  return people;
}

//post method
Future<void> addPeople(String name) async {
  await db.collection("people").add({"name": name});
}

//put method
Future<void> updatePeople(String uid, String newName) async {
  await db.collection("people").doc(uid).set({"name": newName});
}

//delete method
Future<void> deletePeople(String uid) async {
  await db.collection("people").doc(uid).delete();
}

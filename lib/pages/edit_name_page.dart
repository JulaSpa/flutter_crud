import 'package:crud_flutter/services/firebase_service.dart';
import 'package:flutter/material.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditName();
}

class _EditName extends State<EditName> {
  TextEditingController nameController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments
        as Map; //asi tomamos el argumento name que me manda homepage.
    nameController.text = arguments["name"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Name"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController, //almacena la info del textfield.
              decoration: const InputDecoration(hintText: "Modify Name"),
            ),
            ElevatedButton(
                onPressed: () async {
                  await updatePeople(arguments["uid"], nameController.text)
                      .then((_) {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}

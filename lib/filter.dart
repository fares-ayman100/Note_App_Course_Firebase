import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Const/const.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<QueryDocumentSnapshot> data = [];
  initialData() async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot usersdata = await users.where("age", isGreaterThan: 15).get();
    //whereIn[15,40,13]
    //IsEqualTo:40
    //orderBy("age",desecending=false)
    //limit(2)
    for (var element in usersdata.docs) {
      data.add(element);
    }
    setState(() {});
  }

  @override
  void initState() {
    initialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filter',
          style: TextStyle(fontSize: 35),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              subtitle: Text("age :${data[index]["age"]}"),
              title: Text(
                data[index]["username"],
                style: const TextStyle(fontSize: 35),
              ),
            ),
          );
        },
      ),
    );
  }
}

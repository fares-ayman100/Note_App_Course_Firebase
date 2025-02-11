import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Const/const.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kprimarycolor,
        onPressed: () {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          DocumentReference doc1 =
              FirebaseFirestore.instance.collection('users').doc("1");
          DocumentReference doc2 =
              FirebaseFirestore.instance.collection('users').doc("2");
          DocumentReference doc3 =
              FirebaseFirestore.instance.collection('users').doc("3");
          WriteBatch batch = FirebaseFirestore.instance.batch();
          batch.set(doc1, {'username': 'Mohamed', 'age': 15, 'money': 500});
          batch.set(doc2, {'username': 'Kareem', 'age': 21, 'money': 450});
          batch.set(doc3, {'username': 'Ameen', 'age': 60, 'money': 50});
          batch.commit();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Filter',
          style: TextStyle(fontSize: 35),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: usersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> Snapshot) {
            if (Snapshot.hasError) {
              return const Text('Error');
            } else if (Snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: Snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(Snapshot.data!.docs[index].id);
                      FirebaseFirestore.instance.runTransaction(
                        (transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(documentReference);
                          if (snapshot.exists) {
                            var snapShotData = snapshot.data();
                            if (snapShotData is Map<String, dynamic>) {
                              int money = snapShotData['money'] + 100;
                              transaction
                                  .update(documentReference, {"money": money});
                            }
                          }
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        trailing: Text(
                          '${Snapshot.data!.docs[index]['money']}\$',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 30),
                        ),
                        subtitle: Text(
                          "age :${Snapshot.data!.docs[index]["age"]}",
                          style: const TextStyle(fontSize: 25),
                        ),
                        title: Text(
                          Snapshot.data!.docs[index]["username"],
                          style: const TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}

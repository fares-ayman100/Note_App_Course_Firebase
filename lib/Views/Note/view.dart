import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app_firebase/Views/Note/add.dart';
import 'package:notes_app_firebase/Views/Note/edit.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.categoryId});
  final String categoryId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool isLoading = true;
  List data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection('note')
        .get();

    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFFA56F),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(doc_id: widget.categoryId),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Note',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('Login', (route) => false);
              },
              icon: const Icon(
                Icons.exit_to_app,
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 200),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Are you sure you want to delete note',
                            // btnCancelText: 'Delete',
                            // btnOkText: 'Edit',
                            btnCancelOnPress: () async {},
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(widget.categoryId)
                                  .collection('note')
                                  .doc(data[index].id)
                                  .delete();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteView(categoryId: widget.categoryId),
                                ),
                              );
                            }).show();
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditNote(
                                note_doc_Id: data[index].id,
                                value: data[index]['note'],
                                category_doc_Id: widget.categoryId),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [Text('${data[index]['note']}')],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        onWillPop: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('homePage', (route) => false);
          return Future.value(false);
        },
      ),
    );
  }
}

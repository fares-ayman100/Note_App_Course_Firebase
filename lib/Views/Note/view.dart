import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          Navigator.of(context).pushNamed('addPage');
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
      body: isLoading
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
                              desc: 'Choose Edit Or Delete',
                              btnCancelText: 'Delete',
                              btnOkText: 'Edit',
                              btnOkOnPress: () async {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => EditCategory(
                                //         oldName: data[index]['name'],
                                //         docId: data[index].id),
                                //   ),
                                // );
                              },
                              btnCancelOnPress: () async {
                                // await FirebaseFirestore.instance
                                //     .collection('categories')
                                //     .doc(data[index].id)
                                //     .delete();
                                // Navigator.of(context)
                                //     .pushReplacementNamed('homePage');
                              })
                          .show();
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('${data[index]['note']}'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

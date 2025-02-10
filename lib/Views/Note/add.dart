import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Views/Note/view.dart';
import 'package:notes_app_firebase/Widget/CustomTextFormAdd.dart';
import 'package:notes_app_firebase/Widget/Custom_Material_Button.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.doc_id});
  final String doc_id;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  bool isLoading = false;

  AddNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.doc_id)
        .collection('note');
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response = await collectionNote.add({
          'note': note.text,
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteView(categoryId: widget.doc_id),
          ),
        );
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Form(
        key: formstate,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    child: Customtextformadd(
                        label: 'Enter your note',
                        controler: note,
                        validator: (val) {
                          if (val == '') {
                            return 'Can\'t to be Empty';
                          }
                          return null;
                        }),
                  ),
                  CustomMaterialButton(
                      onpressed: () {
                        AddNote();
                      },
                      title: 'Add')
                ],
              ),
      ),
    );
  }
}

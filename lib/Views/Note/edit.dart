import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Views/Note/view.dart';
import 'package:notes_app_firebase/Widget/CustomTextFormAdd.dart';
import 'package:notes_app_firebase/Widget/Custom_Material_Button.dart';

class EditNote extends StatefulWidget {
  const EditNote(
      {super.key,
      required this.note_doc_Id,
      required this.value,
      required this.category_doc_Id});
  final String note_doc_Id;
  final String value;
  final String category_doc_Id;

  @override
  State<EditNote> createState() => _EditNoteState();
}
class _EditNoteState extends State<EditNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isLoading = false;
  EditNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.category_doc_Id)
        .collection('note');
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await collectionNote.doc(widget.note_doc_Id).update({"note": note.text});
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteView(categoryId: widget.category_doc_Id),
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
    note.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    note.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
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
                        EditNote();
                      },
                      title: 'Edit')
                ],
              ),
      ),
    );
  }
}

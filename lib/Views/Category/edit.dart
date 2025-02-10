import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Widget/CustomTextFormAdd.dart';
import 'package:notes_app_firebase/Widget/Custom_Material_Button.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({super.key, required this.oldName, required this.docId});
  final String oldName;
  final String docId;

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;

  // ignore: non_constant_identifier_names
  EditCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.docId).update({'name': name.text});
        Navigator.of(context)
            .pushNamedAndRemoveUntil('homePage', (Route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e);
      }
    }
  }

  
  @override
  void initState() {
    name.text = widget.oldName;
    super.initState();
  }
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
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
                        label: 'Enter Name',
                        controler: name,
                        validator: (val) {
                          if (val == '') {
                            return 'Can\'t to be Empty';
                          }
                          return null;
                        }),
                  ),
                  CustomMaterialButton(
                      onpressed: () {
                        EditCategory();
                      },
                      title: 'Save')
                ],
              ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/Widget/CustomTextFormAdd.dart';
import 'package:notes_app_firebase/Widget/Custom_Material_Button.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  AddCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add(
            {'name': name.text, 'id': FirebaseAuth.instance.currentUser!.uid});
        Navigator.of(context).pushReplacementNamed('homePage');
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Form(
        key: formstate,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
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
                  AddCategory();
                },
                title: 'Add')
          ],
        ),
      ),
    );
  }
}

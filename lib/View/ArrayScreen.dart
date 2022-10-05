// ignore_for_file: file_names

import 'package:tasks/controllers/authController.dart';
import 'package:tasks/controllers/userController.dart';
import 'package:tasks/models/Todo.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/utils/validators.dart';

class ArrayScreen extends StatefulWidget {
  final int? index;
  final String? docId;

  const ArrayScreen({Key? key, this.index, this.docId}) : super(key: key);

  @override
  State<ArrayScreen> createState() => _ArrayScreenState();
}

class _ArrayScreenState extends State<ArrayScreen> {
  final ArrayController arrayController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    String? title = '';

    if (widget.index != null) {
      title = arrayController.arrays[widget.index!].title;
    }

    TextEditingController titleEditingController =
        TextEditingController(text: title);

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text((widget.index == null) ? 'New List' : 'Edit List',
            style: menuTextStyle),
        leadingWidth: 90.0,
        leading: Center(
          child: TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: 20.0, color: primaryColor),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: TextButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                if (widget.index == null && formKey.currentState!.validate()) {
                  Database().addArray(authController.user!.uid,
                      titleEditingController.text, widget.docId ?? '');
                  //arrayController.arrays.add(Array(
                  //title: titleEditingController.text,
                  //id: UniqueKey().hashCode,
                  //todos: []));
                  Get.back();
                  HapticFeedback.heavyImpact();
                }
                if (widget.index != null && formKey.currentState!.validate()) {
                  var editing = arrayController.arrays[widget.index!];
                  editing.title = titleEditingController.text;
                  arrayController.arrays[widget.index!] = editing;
                  Database().updateArray(
                      authController.user!.uid, editing.title!, widget.docId!);
                  Get.back();
                  HapticFeedback.heavyImpact();
                }
              },
              child: Text((widget.index == null) ? 'Add' : 'Update',
                  style: TextStyle(fontSize: 20.0, color: primaryColor)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(14.0)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                            validator: Validator.titleValidator,
                            controller: titleEditingController,
                            autofocus: true,
                            autocorrect: false,
                            cursorColor: Colors.grey,
                            maxLines: 1,
                            maxLength: 25,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                counterStyle: counterTextStyle,
                                hintText: "Title",
                                hintStyle: hintTextStyle,
                                border: InputBorder.none),
                            style: todoScreenStyle),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

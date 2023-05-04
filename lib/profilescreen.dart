import 'dart:io';
import 'package:attendance/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  // Color primary = Color(0xFCEF444C);
  Color primary = Color.fromARGB(255, 255, 166, 0);
  String birth = "Date of Birth";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${User.studentId.toLowerCase()}_profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        User.profilePicLink = value;
      });
      //change

      await FirebaseFirestore.instance
          .collection("student")
          .doc(User.id)
          .update({
        'profilePic': value,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                pickUploadProfilePic();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 80, bottom: 24),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primary,
                ),
                child: Center(
                  child: User.profilePicLink == " "
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(User.profilePicLink)),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                // "Student ${User.studentId}",
                "Hello, Student",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 24),
            User.canEdit
                ? textField("First Name", "First Name", firstNameController)
                : field("First Name", User.firstName),
            User.canEdit
                ? textField("Last Name", "Last Name", lastNameController)
                : field("Last Name", User.lastName),
            User.canEdit
                ? GestureDetector(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primary,
                                  secondary: primary,
                                  onSecondary: Colors.white,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: primary,
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  headline4: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  overline: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  button: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          }).then((value) {
                        setState(() {
                          birth = DateFormat("MM/dd/yyyy").format(value!);
                        });
                      });
                    },
                    child: field("Date of Birth", birth))
                : field("Date of Birth", User.birthDate),
            User.canEdit
                ? textField("Address", "Address", addressController)
                : field("Address", User.address),
            User.canEdit
                ? GestureDetector(
                    onTap: () async {
                      String firstName = firstNameController.text;
                      String lastName = lastNameController.text;
                      String birthDate = birth;
                      String address = addressController.text;

                      if (User.canEdit) {
                        if (firstName.isEmpty) {
                          ShowSnackBar("please enter your first name!");
                        } else if (lastName.isEmpty) {
                          ShowSnackBar("please enter your last name!");
                        } else if (birthDate.isEmpty) {
                          ShowSnackBar("please enter your birth date!");
                        } else if (address.isEmpty) {
                          ShowSnackBar("please enter your address!");
                        } else {
                          await FirebaseFirestore.instance
                              .collection("student")
                              .doc(User.id)
                              .update({
                            'firstName': firstName,
                            'lastName': lastName,
                            'birthDate': birthDate,
                            'address': address,
                            'canEdit': false,
                          }).then((value) {
                            setState(() {
                              User.canEdit = false;
                              User.firstName = firstName;
                              User.lastName = lastName;
                              User.birthDate = birthDate;
                              User.address = address;
                            });
                          });
                        }
                      } else {
                        ShowSnackBar("You can't edit anymore");
                      }
                    },
                    child: Container(
                      height: kToolbarHeight,
                      width: screenWidth,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.only(left: 11),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: primary,
                      ),
                      child: const Center(
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "NexaBold",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              height: kToolbarHeight,
              width: screenWidth,
              margin: const EdgeInsets.only(),
              padding: const EdgeInsets.only(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: primary,
              ),
              child: ElevatedButton(
                onPressed: () {
                  ShowSnackBar("Contact with Admin or teacher for logout!");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, 
                ),
                child: const Text(
                  "LOGOUT",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "NexaBold",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget field(String title, String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.black54,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(
      String hint, String title, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void ShowSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}

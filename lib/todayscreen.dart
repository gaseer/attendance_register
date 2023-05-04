import 'dart:async';
import 'package:attendance/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreen();
}

class _TodayScreen extends State<TodayScreen> {
  List<String> list = <String>[
    'Android',
    'Life Skill',
    'Networking',
    'Operating System'
  ];
  String dropdownValue = 'Android';

  TextEditingController nameController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  // Color primary = Color(0xFCEF444C);
  Color primary = Colors.blue;

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        // reverse: true,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth / 22,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Student" + " " + User.studentId,
                style: TextStyle(
                  color: primary,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 26),
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 26,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "09:30 am",
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 24,
                              color: primary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 26,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "03:30 pm",
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 24,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 25,
                    color: primary,
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 26),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 22,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle("Student name *"),
                  customField("Enter Name", nameController, false),
                  fieldTitle("rollno *"),
                  customField("Enter Rollno", rollnoController, false),
                  fieldTitle("Subject *"),
                  dropField(),
                  // customField("enter subject", subjectController, false),
                  fieldTitle("phone no *"),
                  customField("Enter Phone no", phonenoController, false),
                  GestureDetector(
                    // ontap function here
                    child: Container(
                      height: 60,
                      width: screenWidth,
                      margin: EdgeInsets.only(top: screenHeight / 30),
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          String name = nameController.text.trim();
                          String rollno = rollnoController.text.trim();
                          // String subject = subjectController.text.trim();
                          String phoneno = phonenoController.text.trim();

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Student name is still empty"),
                            ));
                          } else if (rollno.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("roll no is still empty"),
                            ));
                            // } else if (subject.isEmpty) {
                            //   ScaffoldMessenger.of(context)
                            //       .showSnackBar(const SnackBar(
                            //     content: Text("subject is still empty"),
                            //   ));
                          } else if (phoneno.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("phoneno is still empty"),
                            ));
                          } else {
                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("submit")
                                .where('name', isEqualTo: name)
                                .get();
                            try {
                              if (rollno == snap.docs[0]['rollno'] &&
                                  phoneno == snap.docs[0]['phoneno']) {
                                sharedPreferences =
                                    await SharedPreferences.getInstance();

                                // sharedPreferences.setString('studentName', name).then((_){
                                //    Navigator.pushReplacement(context,
                                //    MaterialPageRoute(builder: (context)=> AttendanceScreen()));

                                // });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Attendace successful"),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Deatails no matching"),
                                ));
                              }
                            } catch (e) {
                              String error = " ";
                              print(e.toString());
                              if (e.toString() ==
                                  "RangeError (Index): Invalid value: valid value range is empty: 0") {
                                setState(() {
                                  error = "Student Name does not exist";
                                });
                              } else {
                                setState(() {
                                  error = "Check name & roll no";
                                });
                              }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(error),
                              ));
                            }
                          }
                          String date =DateFormat('dd MM yyyy \n hh:mm:ss a')
                                  .format(DateTime.now());
                          String time =DateFormat('hh:mm:ss a')
                                  .format(DateTime.now());
                         
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("student")
                              .where('id', isEqualTo: User.studentId)
                              .get();

                          print(snap.docs[0].id);

                          DocumentSnapshot snap2 = await FirebaseFirestore
                              .instance
                              .collection("student")
                              .doc(snap.docs[0].id)
                              .collection("record")
                              .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                              .collection("Day")
                              .doc(DateFormat('hh')
                                  .format(DateTime.now()))
                              .get();

                          try {
                            String checkIn = snap2['checkIn'];
                            await FirebaseFirestore.instance
                                .collection("student")
                                .doc(snap.docs[0].id)
                                .collection("record")
                                .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                              .collection("Day")
                              .doc(DateFormat('hh')
                                  .format(DateTime.now()));
                            //   .update({
                            // 'checkIn': checkIn,
                            //  'checkOut': DateFormat('hh:mm').format(DateTime.now()),
                            // });
                          } catch (e) {
                            await FirebaseFirestore.instance
                                .collection("student")
                                .doc(snap.docs[0].id)
                                .collection("record")
                                .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                              .collection("Day")
                              .doc(DateFormat('hh a')
                                  .format(DateTime.now()))
                                .set({
                              'Name': name,
                              'Rollno': rollno,
                              'Subject': dropdownValue,
                              'Phoneno': phoneno,
                              'Date' : date,
                              'Time' : time,
                              'date':Timestamp.now(),
                            });
                          }
                        },
                        child: const Text('SUBMIT'),
                      ),
                    ),
                  ),

                  //slideactionbuttonhere
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: screenHeight / 40, fontFamily: "NexaBold"),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
        width: screenWidth,
        margin: EdgeInsets.only(bottom: screenHeight / 45),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth / 7,
              child: Icon(Icons.person, color: primary, size: screenWidth / 12),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: screenWidth / 12),
                child: TextFormField(
                  controller: controller,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenHeight / 35,
                    ),
                    border: InputBorder.none,
                    hintText: hint,
                  ),
                  maxLines: 1,
                  obscureText: obscure,
                ),
              ),
            ),
          ],
        ));
  }

  Widget dropField() {
    return Container(
      width: screenWidth,
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: screenHeight / 45),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(
          Icons.select_all,
          color: primary,
        ),
        alignment: Alignment.center,
        elevation: 16,
        style: TextStyle(
          color: primary,
          fontFamily: "NexaBold",
          fontSize: screenWidth / 16,
        ),
        underline: Container(
          color: primary,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}



//slideactionbutton
 // Container(
                  //   margin: const EdgeInsets.only(top: 24),
                  //   child: Builder(
                  //     builder: (context) {
                  //       final GlobalKey<SlideActionState> key = GlobalKey();

                  //       return SlideAction(
                  //         text: "Slide to Submit",
                  //         textStyle: TextStyle(
                  //           color: Colors.black54,
                  //           fontSize: screenWidth / 20,
                  //           fontFamily: "NexaRegular",
                  //         ),
                  //         outerColor: Colors.white,
                  //         innerColor: primary,
                  //         key: key,
                  //         onSubmit: () 
                  //            async {
                  //       FocusScope.of(context).unfocus();

                  //       String name = nameController.text.trim();
                  //       String rollno = rollnoController.text.trim();
                  //       // String subject = subjectController.text.trim();
                  //       String phoneno = phonenoController.text.trim();

                  //       if (name.isEmpty) {
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(const SnackBar(
                  //           content: Text("Student name is still empty"),
                  //         ));
                  //       } else if (rollno.isEmpty) {
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(const SnackBar(
                  //           content: Text("roll no is still empty"),
                  //         ));
                  //         // } else if (subject.isEmpty) {
                  //         //   ScaffoldMessenger.of(context)
                  //         //       .showSnackBar(const SnackBar(
                  //         //     content: Text("subject is still empty"),
                  //         //   ));
                  //       } else if (phoneno.isEmpty) {
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(const SnackBar(
                  //           content: Text("phoneno is still empty"),
                  //         ));
                  //       } else {
                  //         QuerySnapshot snap = await FirebaseFirestore.instance
                  //             .collection("submit")
                  //             .where('name', isEqualTo: name)
                  //             .get();
                  //         try {
                  //           if (rollno == snap.docs[0]['rollno'] &&
                  //               phoneno == snap.docs[0]['phoneno']) {
                  //             sharedPreferences =
                  //                 await SharedPreferences.getInstance();

                  //             // sharedPreferences.setString('studentName', name).then((_){
                  //             //    Navigator.pushReplacement(context,
                  //             //    MaterialPageRoute(builder: (context)=> AttendanceScreen()));

                  //             // });
                  //             ScaffoldMessenger.of(context)
                  //                 .showSnackBar(const SnackBar(
                  //               content: Text("Attendace successful"),
                  //             ));
                  //           } else {
                  //             ScaffoldMessenger.of(context)
                  //                 .showSnackBar(const SnackBar(
                  //               content: Text("Deatails no matching"),
                  //             ));
                  //           }
                  //         } catch (e) {
                  //           String error = " ";
                  //           print(e.toString());
                  //           if (e.toString() ==
                  //               "RangeError (Index): Invalid value: valid value range is empty: 0") {
                  //             setState(() {
                  //               error = "Student Name does not exist";
                  //             });
                  //           } else {
                  //             setState(() {
                  //               error = "Check name & roll no";
                  //             });
                  //           }

                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //             content: Text(error),
                  //           ));
                  //         }
                  //       }
                  //     },
                          
                  //       );
                  //     },
                  //   ),
                  // ),


//ontap function here

// onTap: () async {
                    //   FocusScope.of(context).unfocus();

                    //   String name = nameController.text.trim();
                    //   String rollno = rollnoController.text.trim();
                    //   // String subject = subjectController.text.trim();
                    //   String phoneno = phonenoController.text.trim();

                    //   if (name.isEmpty) {
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(const SnackBar(
                    //       content: Text("Student name is still empty"),
                    //     ));
                    //   } else if (rollno.isEmpty) {
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(const SnackBar(
                    //       content: Text("roll no is still empty"),
                    //     ));
                    //     // } else if (subject.isEmpty) {
                    //     //   ScaffoldMessenger.of(context)
                    //     //       .showSnackBar(const SnackBar(
                    //     //     content: Text("subject is still empty"),
                    //     //   ));
                    //   } else if (phoneno.isEmpty) {
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(const SnackBar(
                    //       content: Text("phoneno is still empty"),
                    //     ));
                    //   } else {
                    //     QuerySnapshot snap = await FirebaseFirestore.instance
                    //         .collection("submit")
                    //         .where('name', isEqualTo: name)
                    //         .get();
                    //     try {
                    //       if (rollno == snap.docs[0]['rollno'] &&
                    //           phoneno == snap.docs[0]['phoneno']) {
                    //         sharedPreferences =
                    //             await SharedPreferences.getInstance();

                    //         // sharedPreferences.setString('studentName', name).then((_){
                    //         //    Navigator.pushReplacement(context,
                    //         //    MaterialPageRoute(builder: (context)=> AttendanceScreen()));

                    //         // });
                    //         ScaffoldMessenger.of(context)
                    //             .showSnackBar(const SnackBar(
                    //           content: Text("Attendace successful"),
                    //         ));
                    //       } else {
                    //         ScaffoldMessenger.of(context)
                    //             .showSnackBar(const SnackBar(
                    //           content: Text("Deatails no matching"),
                    //         ));
                    //       }
                    //     } catch (e) {
                    //       String error = " ";
                    //       print(e.toString());
                    //       if (e.toString() ==
                    //           "RangeError (Index): Invalid value: valid value range is empty: 0") {
                    //         setState(() {
                    //           error = "Student Name does not exist";
                    //         });
                    //       } else {
                    //         setState(() {
                    //           error = "Check name & roll no";
                    //         });
                    //       }

                    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text(error),
                    //       ));
                    //     }
                    //   }
                    // },
                    // child: Container(
                    //   height: 60,
                    //   width: screenWidth,
                    //   margin: EdgeInsets.only(top: screenHeight / 30),
                    //   decoration: BoxDecoration(
                    //     color: primary,
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(30)),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "SUBMIT",
                    //       style: TextStyle(
                    //         fontFamily: "NexaBold",
                    //         fontSize: screenWidth / 26,
                    //         color: Colors.white,
                    //         letterSpacing: 2,
                    //       ),

                    //     ),

                    //   ),

                    // ),

//today attendance
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 10, bottom: 15),
            //   child: Text(
            //     "Today's Attendance",
            //     style: TextStyle(
            //       color: Colors.grey,
            //       fontFamily: "NexaRegular",
            //       fontSize: screenWidth / 26,
            //     ),
            //   ),
            // ),
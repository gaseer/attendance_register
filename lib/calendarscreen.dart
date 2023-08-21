import 'package:attendance/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  // Color primary = Color(0xFCEF444C);
  Color primary = Color.fromARGB(255, 37, 230, 134);

  String _month = DateFormat('dd MMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              "My Attendance",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "NexaBold",
                fontSize: 18,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  _month,
                  style: TextStyle(
                    color: primary,
                    fontFamily: "NexaBold",
                    fontSize: 26,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () async{
                    final month = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2099),
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
                                foregroundColor: primary
                              )
                            ),
                            textTheme: const TextTheme(
                              headline4: TextStyle(
                                fontFamily: "NexaBold"
                              ),
                              overline: TextStyle(
                                fontFamily: "NexaBold"
                              ),
                              button: TextStyle(
                                fontFamily: "NexaBold"
                              )

                            ),
                          ), 
                          child: child!,
                          );
                      }
                      );

                      if(month != null){
                        setState(() {
                          _month = DateFormat('dd MMM yyyy').format(month);
                        });
                      }
                  },
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
              height: screenHeight /1.6,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("student")
                      .doc(User.id)
                      .collection("record")
                      .doc(User.date)
                      .collection("Day")
                      .where("date")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return DateFormat('dd MMM yyyy')
                                      .format(snap[index]['date'].toDate()) ==
                                  _month
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: index > 0 ? 12 : 0, left: 6, right: 6, bottom: 12),
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(2, 2),
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(),
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.horizontal(),
                                          ),
                                          child: Center(
                                            child: Text(
                                              DateFormat('EEEE dd').format(
                                                  snap[index]['date'].toDate()),
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Name:  ",
                                                style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 24,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                snap[index]['Name'],
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
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Rollno:  ",
                                                style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 24,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                snap[index]['Rollno'],
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
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Subject:  ",
                                                style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 24,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                snap[index]['Subject'],
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
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Date&Time:  ",
                                                style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 24,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                snap[index]['Date'],
                                                style: TextStyle(
                                                  fontFamily: "NexaBold",
                                                  fontSize: screenWidth / 30,
                                                  color: primary,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Phoneno:  ",
                                                style: TextStyle(
                                                  fontFamily: "NexaRegular",
                                                  fontSize: screenWidth / 24,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                snap[index]['Phoneno'],
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
                                )
                              : const SizedBox();
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }))
        ],
      ),
    ));
  }
}

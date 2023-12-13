import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_tes/form.dart';

void main() async {
  // do initialization to use firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      //remove the debug banner
      debugShowCheckedModeBanner: false,
      title: "Flutter Contact Firebase",
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // The Entry point for accessing a [FirebaseFirestore]
    FirebaseFirestore firebase = FirebaseFirestore.instance;

    // Get collection from firebase, collection is table in mysql
    CollectionReference users = firebase.collection("users");
    return Scaffold(
      appBar: AppBar(
        // Make appbar with Icon
        title: Center(
          child: Text("Contact APP"),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        //data to be retrievid in the future
        future: users.get(),
        builder: (_, snapshot) {
          // show if there is data
          if (snapshot.hasData) {
            // we take the document and pass it to a variable
            var alldata = snapshot.data!.docs;

            //if there is data, make list
            return alldata.length != 0
                ? ListView.builder(

                    // diplayed as much as the variable data alldata
                    itemCount: alldata.length,

                    // make cunstom item with list tile.
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          // get first character of name
                          child: Text(alldata[index]["name"][0]),
                        ),
                        title: Text(alldata[index]["name"],
                            style: TextStyle(fontSize: 20)),
                        subtitle: Text(alldata[index]["phonenumber"],
                            style: TextStyle(fontSize: 16)),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  // pass data to edit form
                                  MaterialPageRoute(
                                      builder: (context) => FormPage(
                                            id: snapshot.data!.docs[index].id,
                                          )));
                            },
                            icon: Icon(Icons.arrow_forward_rounded)),
                      );
                    })
                : Center(
                    child: Text(
                      " No Data",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
          } else {
            return Center(child: Text("Loading...."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

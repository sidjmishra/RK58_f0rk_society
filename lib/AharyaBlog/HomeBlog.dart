import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListPost extends StatefulWidget {
  @override
  _ListPostState createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot querySnapshot =
        await firestore.collection('Blog Retrieve').orderBy('Timestamp', descending: true).getDocuments();
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getPosts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  String url = snapshot.data[index].data['imageUrl'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(225, 95, 27, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(snapshot.data[index].data['Date Posted']),
                                Text(snapshot.data[index].data['Time Posted']),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image.network(
                                url,
                                height: 200.0,
                              ),
                            ),
                            snapshot.data[index].data['Role'] == 'Official' ? Row(
                              children: <Widget>[
                                Text('Official: ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                Text(snapshot.data[index].data['Description'],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ) : Text(snapshot.data[index].data['Description'],
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

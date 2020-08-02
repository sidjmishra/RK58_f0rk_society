import 'package:block/Animation/FadeAnimation.dart';
import 'package:block/views/BribeBlog/UploadBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ListPost extends StatefulWidget {
  @override
  _ListPostState createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {

  QuerySnapshot querySnapshot;

  Future getPosts() async {
    var firestore = Firestore.instance;
    querySnapshot = await firestore.collection('Blog Retrieve').orderBy('Timestamp', descending: true).getDocuments();
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return UploadBlog();
              }));
        },
        tooltip: 'Add Blog',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text('Aharya Blog',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: FadeAnimation(
            1,
            FutureBuilder(
              future: getPosts(),
              builder: (_, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
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
                                  color: Color(0xff99D5D5),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
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
                                    child: Image.network(url,
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
          ),
        ),
      ),
    );
  }
}
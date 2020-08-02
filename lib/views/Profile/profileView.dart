import 'package:block/modal/constants.dart';
import 'package:block/services/database.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  String name;
  String date;
  String gender;
  String address;
  String phone;
  String city;
  String pincode;
  String state;
  String idType;
  String idNumber;

  Future getPosts() async {
    print(Constants.myUid);
    await dataMethods.getProfile(Constants.myUid).then((value) {
        querySnapshot = value;
        print(querySnapshot.documents.length);
        for (var index = 0; index < querySnapshot.documents.length; index++) {
          print(index);
          if (querySnapshot.documents[index].data['uid'] == Constants.myUid) {
            setState(() {
              name = querySnapshot.documents[index].data['First Name'] + ' ' + querySnapshot.documents[index].data['Last Name'];
              date = querySnapshot.documents[index].data['Date of Birth'];
              gender = querySnapshot.documents[index].data['Gender'];
              address = querySnapshot.documents[index].data['Address Line 1'] + ' ' + querySnapshot.documents[index].data['Address Line 2'];
              phone = querySnapshot.documents[index].data['Phone Number'];
              city = querySnapshot.documents[index].data['City'];
              pincode = querySnapshot.documents[index].data['Pincode'];
              state = querySnapshot.documents[index].data['State'];
              idType = querySnapshot.documents[index].data['U.I.D type'];
              idNumber = querySnapshot.documents[index].data['U.I.D number'];
            });
          }
        }
    });
  }

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: HotConstants.myPhone == ''
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Text('User Not verified'),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Profile()
                ));
              },
              color: Colors.orangeAccent,
              child: Text('Add Information'),
            ),
        ],
      ),
          ) : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.orange[200],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Icon(Icons.supervised_user_circle,
                      color: Colors.black,
                      size: 90.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  DataDisplay(
                    field: 'Date of Birth',
                    data: date,
                  ),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: 'Name',
                    data: name,
                  ),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: 'Gender',
                    data: gender,
                  ),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: 'Phone',
                    data: phone,
                  ),
                  SizedBox(height: 10.0),
                  Text('Address: ', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  )),
                  Text(address , maxLines: 3, style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  )),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: 'Pincode',
                    data: pincode,
                  ),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: 'City',
                    data: city,
                  ),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: 'Sate',
                    data: state,
                  ),
                  SizedBox(height: 10.0),
                  DataDisplay(
                    field: idType,
                    data: idNumber,
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Profile()
                      ));
                    },
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 123,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.orange[400],
                        ),
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DataDisplay extends StatelessWidget {

  final String field;
  final String data;

  DataDisplay({this.field, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(field + ': ', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600
        )),
        SizedBox(width: 10.0),
        Text(data , maxLines: 3, style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400
        )),
      ],
    );
  }
}


import 'package:block/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Feedback.dart';

class Paid extends StatefulWidget {
  final String uid;
  Paid({this.uid});

  @override
  _PaidState createState() => _PaidState();
}

class _PaidState extends State<Paid> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('PaidBribe', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'Bribe Report Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'PaidBribe',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot
                                              .documents[index].data['email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Date of Incident: ' +
                                        querySnapshot
                                            .documents[index].data['date'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Category: ' +
                                        querySnapshot
                                            .documents[index].data['category'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Pincode: ' +
                                        querySnapshot
                                            .documents[index].data['pincode'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'City: ' +
                                        querySnapshot
                                            .documents[index].data['city'],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Details: ' +
                                        querySnapshot
                                            .documents[index].data['details'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Amount: ₹' +
                                        querySnapshot
                                            .documents[index].data['amount'],
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class HotStatus extends StatefulWidget {
  final String uid;
  HotStatus({this.uid});

  @override
  _HotStatusState createState() => _HotStatusState();
}

class _HotStatusState extends State<HotStatus> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('Hot Report', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'Hot Report Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'Hot Report',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Complaint ID: ' +
                                          querySnapshot.documents[index]
                                              .data['complaintID']),
                                      Text('Name: ' +
                                          querySnapshot.documents[index]
                                              .data['Full Name']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Date of Incident: ' +
                                        querySnapshot.documents[index]
                                            .data['Start Stamp'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Phone Number: ' +
                                        querySnapshot.documents[index]
                                            .data['Phone Number'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Incident Location: ' +
                                        querySnapshot.documents[index]
                                            .data['Current Location'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'U.I.D: ' +
                                        querySnapshot
                                            .documents[index].data['U.I.D'],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class Unusual extends StatefulWidget {
  final String uid;
  Unusual({this.uid});

  @override
  _UnusualState createState() => _UnusualState();
}

class _UnusualState extends State<Unusual> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('UnusualBehaviour', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'Unusual Incident Report',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'UnusualBehaviour',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot
                                              .documents[index].data['email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Date: ' +
                                        querySnapshot
                                            .documents[index].data['date'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Category: ' +
                                        querySnapshot
                                            .documents[index].data['category'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Official\'s Name: ' +
                                        querySnapshot
                                            .documents[index].data['Official'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'City: ' +
                                        querySnapshot
                                            .documents[index].data['city'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Pincode: ' +
                                        querySnapshot
                                            .documents[index].data['pincode'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Details: ' +
                                        querySnapshot
                                            .documents[index].data['details'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class FIR extends StatefulWidget {
  final String typeReport;
  final String uid;
  FIR({this.uid, this.typeReport});

  @override
  _FIRState createState() => _FIRState();
}

class _FIRState extends State<FIR> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  Future getUserData(String coll, String uid) async {
    return await Firestore.instance
        .collection(coll)
        .document(uid)
        .collection(widget.typeReport)
        .getDocuments();
  }

  void getPosts() {
    getUserData('FIR_NCR', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          '${widget.typeReport} Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'FIR_NCR',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot
                                              .documents[index].data['email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Category: ' +
                                        querySnapshot
                                            .documents[index].data['category'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Date: ' +
                                        querySnapshot.documents[index]
                                            .data['Date of Incident'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Pincode: ' +
                                        querySnapshot
                                            .documents[index].data['pincode'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'City: ' +
                                        querySnapshot
                                            .documents[index].data['city'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Details: ' +
                                        querySnapshot.documents[index]
                                            .data['Details of Incident'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Suspect: ' +
                                        querySnapshot.documents[index]
                                            .data['Details of Suspect'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    querySnapshot.documents[index]
                                            .data['U.I.D. Type'] +
                                        ': ' +
                                        querySnapshot.documents[index]
                                            .data['U.I.D. Number'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class NOC extends StatefulWidget {
  final String uid;
  NOC({this.uid});

  @override
  _NOCState createState() => _NOCState();
}

class _NOCState extends State<NOC> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('NOC', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'NOC Report Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'NOC',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot
                                              .documents[index].data['email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Name: ' +
                                        querySnapshot
                                            .documents[index].data['name'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Address: ' +
                                        querySnapshot
                                            .documents[index].data['address1'] +
                                        ', ' +
                                        querySnapshot
                                            .documents[index].data['address2'],
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Pincode: ' +
                                        querySnapshot
                                            .documents[index].data['pincode'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Purpose: ' +
                                        querySnapshot
                                            .documents[index].data['purpose'],
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Description: ' +
                                        querySnapshot.documents[index]
                                            .data['description'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class RTI extends StatefulWidget {
  final String uid;
  RTI({this.uid});

  @override
  _RTIState createState() => _RTIState();
}

class _RTIState extends State<RTI> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('Delay in Actions', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'Right To Information Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'Delay In Actions',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot.documents[index]
                                              .data['User Email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Name: ' +
                                        querySnapshot
                                            .documents[index].data['Full Name'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Application Type: ' +
                                        querySnapshot.documents[index]
                                            .data['ApplicationType'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Requested Complain ID: ' +
                                        querySnapshot.documents[index]
                                            .data['Requested Complain ID'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'User Identification: ' +
                                        querySnapshot.documents[index]
                                            .data['User Identification'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Phone Number: ' +
                                        querySnapshot.documents[index]
                                            .data['User Contact'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class Apoint extends StatefulWidget {
  final String uid;
  Apoint({this.uid});

  @override
  _ApointState createState() => _ApointState();
}

class _ApointState extends State<Apoint> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('Appointment', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'Appointment Status',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'Appointment',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot
                                              .documents[index].data['email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Requested Date: ' +
                                        querySnapshot.documents[index]
                                            .data['DateofAppointment'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'ConfirmedDate : ' +
                                        querySnapshot.documents[index]
                                            .data['Confirmed Date'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Name: ' +
                                        querySnapshot
                                            .documents[index].data['Full Name'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'City: ' +
                                        querySnapshot
                                            .documents[index].data['city'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Address: ' +
                                        querySnapshot
                                            .documents[index].data['address1'] +
                                        ', ' +
                                        querySnapshot
                                            .documents[index].data['address2'],
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Pincode: ' +
                                        querySnapshot
                                            .documents[index].data['pincode'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Reason: ' +
                                        querySnapshot
                                            .documents[index].data['Reason'],
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Description: ' +
                                        querySnapshot.documents[index]
                                            .data['DetailsofAppointment'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

class Jail extends StatefulWidget {
  final String uid;
  Jail({this.uid});

  @override
  _JailState createState() => _JailState();
}

class _JailState extends State<Jail> {
  DataMethods dataMethods = DataMethods();
  QuerySnapshot querySnapshot;

  void getPosts() {
    dataMethods.getUserData('Jail Management', widget.uid).then((value) {
      setState(() {
        querySnapshot = value;
      });
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
        title: Text(
          'Jail Management',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Container(
            child: querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          onPressed: () {
                            if (querySnapshot.documents[index].data['Status'] ==
                                'Accepted') {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbackPage(
                                            type: 'PaidBribe',
                                            uid: widget.uid,
                                            docid: querySnapshot
                                                .documents[index].data['id'],
                                          )));
                            }
                          },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('ID: ' +
                                          querySnapshot
                                              .documents[index].data['id']),
                                      Text('Email: ' +
                                          querySnapshot
                                              .documents[index].data['email']),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Date of Incident: ' +
                                        querySnapshot.documents[index]
                                            .data['DateofIncident'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Name: ' +
                                        querySnapshot
                                            .documents[index].data['Full Name'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'User Role: ' +
                                        querySnapshot
                                            .documents[index].data['User Role'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Address: ' +
                                        querySnapshot
                                            .documents[index].data['address1'] +
                                        ', ' +
                                        querySnapshot
                                            .documents[index].data['address2'],
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'City: ' +
                                        querySnapshot
                                            .documents[index].data['city'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Pincode: ' +
                                        querySnapshot
                                            .documents[index].data['pincode'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Issue Category: ' +
                                        querySnapshot.documents[index]
                                            .data['IssueCategory'],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Description: ' +
                                        querySnapshot.documents[index]
                                            .data['Details of Complain'],
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Status: ' +
                                        querySnapshot
                                            .documents[index].data['Status'],
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                : Container()),
      ),
    );
  }
}

import 'package:block/modal/constants.dart';
import 'package:block/views/Bribe/paidBribe.dart';
import 'package:block/views/Bribe/unusualIncident.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:flutter/material.dart';

class BribeReport extends StatefulWidget {
  @override
  _BribeReportState createState() => _BribeReportState();
}

class _BribeReportState extends State<BribeReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bribe Reporting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: HotConstants.myPhone == null
          ? Column(
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
      ) :  SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60)),
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.orange[200],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/bprd.png',
                              width: 50.0,
                              height: 50.0,
                            ),
                            SizedBox(width: 20.0),
                            Text('Bribe Reporting',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text('A simple way to report if you have paid a bribe with assured security of evidence while submitting the data. The fast to make your complain reach the higher officials of Police Department for quick actions.',
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => PaidBribe()
                            ));
                          },
                          child: Row(
                            children: <Widget>[
                              Text('Bribe Reporting',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Icon(Icons.arrow_forward,
                                color: Colors.orangeAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.orange[200],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/bprd.png',
                              width: 50.0,
                              height: 50.0,
                            ),
                            SizedBox(width: 20.0),
                            Text('Unusual Incident Report',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text('A simple way to report if you have faced an unusual incident with some official like asking bribe or unusual behaviour while attending you. The fast to make your complain reach the higher officials of Police Department for quick actions.',
                          maxLines: 10,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => HonestOfficial()
                            ));
                          },
                          child: Row(
                            children: <Widget>[
                              Text('Unusual Incident',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Icon(Icons.arrow_forward,
                                color: Colors.orangeAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

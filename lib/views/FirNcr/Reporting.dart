import 'package:block/modal/constants.dart';
import 'package:block/views/FirNcr/FirNcr.dart';
import 'package:block/views/Profile/profile.dart';
import 'package:flutter/material.dart';

class Reporting extends StatefulWidget {
  @override
  _ReportingState createState() => _ReportingState();
}

class _ReportingState extends State<Reporting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reporting',
          style: TextStyle(color: Colors.white),
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

                // FIR
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.38),
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
                            Text('FIR Reporting',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text('Report a FIR(First Information Report) if you have faced any wrongdoing or injust incident. The FIR Reporting refers to crime reporting if it is related to major incidents like murder, rape etc.',
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
                                builder: (context) => NCRFiling(typeReport: 'FIR')
                            ));
                          },
                          child: Row(
                            children: <Widget>[
                              Text('FIR Reporting',
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

                // NCR
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (0.38),
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
                            Text('NCR Reporting',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text('Report a NCr(Non-Cognizable Report) if you have faced any wrongdoing or injust incident. The NCR Reporting refers to crime reporting if the crime is related to minor incidents like cheating, assault etc.',
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
                                builder: (context) => NCRFiling(typeReport: 'NCR')
                            ));
                          },
                          child: Row(
                            children: <Widget>[
                              Text('NCR Reporting',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

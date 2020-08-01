import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Helpline Numbers',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            colors: [
//              Colors.orange[900],
//              Colors.orange[800],
//              Colors.orange[400],
//            ],
//          ),
//        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.yellow[900],
                      Colors.yellow[800],
                      Colors.yellow[400],
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset('assets/help.png',
                          height: 230.0,
                        ),
                        Text('Click to dial number',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Contain(name: 'NATIONAL EMERGENCY NUMBER', number: '112'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'POLICE', number: '100'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'FIRE', number: '101'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'HOSPITAL', number: '102'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Disaster Management Services', number: '108'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Women Helpline', number: '1091'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Women Helpline - ( Domestic Abuse )',
                            number: '181'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Air Ambulance', number: '9540161344'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Aids Helpline', number: '1097'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Anti Poison ( New Delhi )', number: '1066'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Anti Poison ( New Delhi )',
                            number: '011-1066'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Disaster Management ( N.D.M.A )',
                            number: '1078'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Disaster Management ( N.D.M.A )',
                            number: '011-26701728 '),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name:
                                'EARTHQUAKE / FLOOD / DISASTER  ( N.D.R.F Headquaters )',
                            number: '011-24363260'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'NDRF HELPLINE NO', number: '9711077372'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name:
                                'Deputy Commissioner Of Police – Missing Child And Women',
                            number: '1094'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Railway Enquiry', number: '139'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Senior Citizen Helpline', number: '1091'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Senior Citizen Helpline', number: '1291'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Railway Accident Emergency Service',
                            number: '1072'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Road Accident Emergency Service',
                            number: '1073'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Road Accident Emergency Service On'
                                '\n National Highway For Private Operators',
                            number: '1033'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name:
                                'ORBO Centre, AIIMS (For Donation Of Organ) Delhi',
                            number: '1060'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Kisan Call Centre', number: '1551'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Relief Commissioner For Natural Calamities',
                            number: '1070'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name: 'Children In Difficult Situation',
                            number: '1098'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name:
                                'All India Institute of Medical Sciences (AIIMS) Poision Control ( 24*7 )',
                            number: '011-26593677'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name:
                                'All India Institute of Medical Sciences (AIIMS) Poision Control ( 24*7 )',
                            number: '26589391'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(
                            name:
                                'All India Institute of Medical Sciences (AIIMS) Poision Control ( 24*7 )',
                            number: '26583282'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Tourist Helpline', number: '1363'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'Tourist Helpline', number: '1800111363'),
                        SizedBox(
                          height: 2.0,
                          width: 50.0,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Contain(name: 'LPG Leak Helpline', number: '1906'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Contain extends StatelessWidget {
  String name;
  String number;

  Contain({@required this.name, @required this.number});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String sms = 'tel:$number';
        launch(sms);
      },
      child: Container(
        height: 45.0,
        width: 300.0,
        child: Center(
          child: Text(
            '$name: $number',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

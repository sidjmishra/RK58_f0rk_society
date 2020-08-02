import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';

class Dropdown extends StatefulWidget {
  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  final _states = [
    'Andhra Pradesh',
    'Andaman and Nicobar',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and kashmir',
    'Ladakh',
    'Lakshadweep',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttarakhand',
    'Uttar Pradesh',
    'West Bengal'
  ];
  var _currentItemSelected;
  TextEditingController state = TextEditingController();
  var category;
  String hint = 'Select State';
  var stateName;
  var officeName;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      1.3,
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xff99D5D5),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: FadeAnimation(
          1.5,
          Column(
            children: <Widget>[
              Container(
                child: DropdownButton<String>(
                  items: _states.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  value: _currentItemSelected,
                  onChanged: (String newValueSelected) {
                    setState(() {
                      this._currentItemSelected = newValueSelected;
                    });
                  },
                  hint: Text(
                    hint,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetState() {
    _currentItemSelected = null;
  }
}

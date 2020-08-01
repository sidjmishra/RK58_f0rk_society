import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';

class Dropdown extends StatefulWidget {
  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  var _states = ['Maharashtra', 'Karnataka', 'Tamil Nadu'];
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
              color: Color.fromRGBO(225, 95, 27, .3),
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

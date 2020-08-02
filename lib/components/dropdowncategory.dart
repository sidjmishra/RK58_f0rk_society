import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';

class DropdownCategory extends StatefulWidget {
  @override
  DropdownCategoryState createState() => DropdownCategoryState();
}

class DropdownCategoryState extends State<DropdownCategory> {
  var _category = ['Police', 'Traffic', 'Land Survey'];
  var _currentSelectedCategory;
  var selection;
  var category;
  String hintCategory = 'Select Category';
  var stateName;
  var officeName;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      1,
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
          1,
          Column(
            children: <Widget>[
              Container(
                child: DropdownButton<String>(
                  items: _category.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  value: _currentSelectedCategory,
                  onChanged: (String newValueSelected) {
                    setState(() {
                      this._currentSelectedCategory = newValueSelected;
                    });
                  },
                  hint: Text(
                    hintCategory,
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

  void resetCategoty() {
    _currentSelectedCategory = null;
  }
}

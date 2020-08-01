import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';

class DatePickerFunction extends StatefulWidget {
  @override
  DatePickerFunctionState createState() => DatePickerFunctionState();
}

class DatePickerFunctionState extends State<DatePickerFunction> {
  DateTime pickedDate;
  TextEditingController dateCtl = TextEditingController();
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
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]),
                  ),
                ),
                child: TextFormField(
                  controller: dateCtl,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime date = DateTime(2000);
                    FocusScope.of(context).requestFocus(FocusNode());
                    date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    dateCtl.text = date.toIso8601String().substring(0, 10);
                  },
                  maxLength: 10,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter the Date',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetDateController() {
    dateCtl.clear();
  }
}

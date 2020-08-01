import 'package:flutter/material.dart';
import 'package:block/Animation/FadeAnimation.dart';

class TextInputField extends StatelessWidget {
  TextInputField({@required this.hintText, this.wordLenght = 100});

  final String hintText;
  final int wordLenght;

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
                  maxLength: wordLenght,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  //TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

Widget appBar(BuildContext context){
  return RichText(
      text: TextSpan(
          text: '',
          style: TextStyle(fontSize: 22),
          children: <TextSpan>[
            TextSpan(text: 'Quiz App', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          ]
      )
  );
}

Widget Button1(BuildContext context, String label, buttonWidth, buttonColor) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    width: buttonWidth,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
Widget Button2(BuildContext context, String label, buttonWidth, buttonColor){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    width: buttonWidth,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
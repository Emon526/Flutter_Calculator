// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ButtonsWidget extends StatelessWidget {
  ButtonsWidget({
    Key? key,
    required this.onTap,
    required this.buttonText,
    required this.buttoncolor,
    required this.textColor,
  }) : super(key: key);
  final String buttonText;
  final Color? buttoncolor;
  final Color? textColor;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: buttoncolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          // log(buttonText);
          onTap();
        },
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 25,
              color: textColor,
              // color: isOperation
              //     ? Theme.of(context).primaryColor
              //     : Theme.of(context).canvasColor,
            ),
          ),
        ),
      ),
    );
  }
}

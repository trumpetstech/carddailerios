import 'package:flutter/material.dart';

class BoxShadowInput extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final onChangeTrigger;
  final hasError;
  final initialValue;

  const BoxShadowInput(
      {Key key,
      this.hintText,
      this.inputType,
      this.onChangeTrigger,
      this.hasError,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: hasError
              ? Border.all(color: Colors.red)
              : Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: TextFormField(
            style: TextStyle(fontSize: 16),
            initialValue: initialValue,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none),
            keyboardType: inputType,
            onChanged: (value) {
              onChangeTrigger(value);
            },
          ),
        ));
  }
}

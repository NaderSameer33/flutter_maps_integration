import 'package:flutter/material.dart';

class CustomTextFild extends StatelessWidget {
  const CustomTextFild({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.length < 2) {
          return 'please typing more than 2 number';
        }
        return null;
      },
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      controller: controller,
      decoration: InputDecoration(
        labelText: 'search',
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}


// todo if you want to create a places api 
// you can move our steps places autoComplete api (api key , session token create uuid pekcage , String text fild) , 
// 
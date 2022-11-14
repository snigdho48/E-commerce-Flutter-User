import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';

showCityInputDialog({
  required BuildContext context,
  required String title,
  String positiveButton = 'OK',
  String negativeButton = 'CLOSE',
  required Function(String) onSubmit,

}) {
  TextEditingController country=TextEditingController();
  TextEditingController state=TextEditingController();
  TextEditingController city=TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(

      content:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CountryStateCityPicker(
            country: country,
            state: state,
            city: city,
            textFieldInputBorder: UnderlineInputBorder(),
          ),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancle'),
        ),
        TextButton(
          onPressed: () {
            if ((country.text+state.text+city.text).isEmpty) return;
            final value = ('${country.text},${state.text},${city.text}').toString();
            onSubmit(value);
            Navigator.pop(context);

          },
          child: Text('Ok'),
        ),
      ],
    ),
  );
}

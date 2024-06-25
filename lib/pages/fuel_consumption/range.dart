import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Range extends StatefulWidget {
  @override
  _RangeState createState() => _RangeState();
}

class _RangeState extends State<Range> {
  double? consuption = null;
  double? fuelCost = null;
  double? price = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextField(
              decoration:
                  InputDecoration(labelText: 'Average fuel consumption (l/100km)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              onChanged: (consuptionInput) {
                setState(() {
                  consuption = double.tryParse(consuptionInput);
                });
              },
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Value of fuel'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              onChanged: (fuelCostInput) {
                setState(() {
                  fuelCost = double.tryParse(fuelCostInput);
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Fuel price per liter'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              onChanged: (priceInput) {
                setState(() {
                  price = double.tryParse(priceInput);
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: consuption != null && fuelCost != null && price != null
                  ? Text('Estimated range: ' +
                      ((fuelCost! / price!) / consuption! * 100)
                          .toStringAsFixed(2) +
                      ' km')
                  : Text(''),
            )
          ],
        ),
      ),
    );
  }
}

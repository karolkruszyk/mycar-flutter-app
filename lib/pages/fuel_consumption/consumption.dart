import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Consumption extends StatefulWidget {
  @override
  _ConsumptionState createState() => _ConsumptionState();
}

class _ConsumptionState extends State<Consumption> {
  double? fuel = null;
  double? distance = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Fuel in liters'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              onChanged: (fuelInput) {
                setState(() {
                  fuel = double.tryParse(fuelInput);
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Distance in kilometers'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              onChanged: (distanceInput) {
                setState(() {
                  distance = double.tryParse(distanceInput);
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: fuel != null && distance != null
                  ? Text(
                      'Average fuel consumption: ' +
                          (fuel! / (distance! / 100)).toStringAsFixed(1) +
                          'l/100km',
                    )
                  : Text(''),
            )
          ],
        ),
      ),
    );
  }
}

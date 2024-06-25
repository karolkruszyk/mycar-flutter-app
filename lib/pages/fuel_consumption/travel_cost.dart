import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TravelCost extends StatefulWidget {
  @override
  _TravelCostState createState() => _TravelCostState();
}

class _TravelCostState extends State<TravelCost> {
  double? consuption = null;
  double? distance = null;
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
              decoration: InputDecoration(labelText: 'Distance (km)'),
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
              child: consuption != null && distance != null && price != null
                  ? Text('Estimated travel cost: ' +
                      ((consuption! * (distance! / 100)) * price!)
                          .toStringAsFixed(2) +
                      ' zł')
                  : Text(''),
            )
          ],
        ),
      ),
    );
  }
}

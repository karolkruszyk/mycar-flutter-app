import 'package:flutter/material.dart';
import 'package:mycar/pages/fuel_consumption/consumption.dart';
import 'package:mycar/pages/fuel_consumption/range.dart';
import 'package:mycar/pages/fuel_consumption/travel_cost.dart';

class FuelConsumptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Fuel consumption'),
              Tab(text: 'Travel cost'),
              Tab(text: 'Range'),
            ],
          ),
          title: const Text('Fuel consumption calculator'),
        ),
        body: TabBarView(
          children: [
            Consumption(),
            TravelCost(),
            Range(),
          ],
        ),
      ),
    );
  }
}

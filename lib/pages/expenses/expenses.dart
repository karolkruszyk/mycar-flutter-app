import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycar/pages/db_helper.dart';
import 'package:mycar/pages/documentation/file.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      const DropdownMenuItem(child: Text('Week'), value: 7),
      const DropdownMenuItem(child: Text('Month'), value: 30),
      const DropdownMenuItem(
        child: Text('Year'),
        value: 365,
      ),
      const DropdownMenuItem(
        child: Text('All'),
        value: 0,
      ),
    ];
    return menuItems;
  }

  int daysToShow = 0;
  bool reload = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
        ),
        body: FutureBuilder(
            future: DbHelper.getAllFiles(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Select the period'),
                          DropdownButton<int>(
                              value: daysToShow == 0
                                  ? dropdownItems.last.value
                                  : daysToShow,
                              items: dropdownItems,
                              onChanged: (int? newValue) {
                                setState(
                                  () {
                                    daysToShow = newValue!;
                                  },
                                );
                              }),
                        ],
                      ),
                      expenseList(snapshot.data),
                      categoryPriceList(snapshot.data),
                      dataBody(snapshot.data),
                      SizedBox(
                        height: 70.0,
                      )
                    ]);
              }
              return Center();
            }),
      ),
    );
  }

  Text dataBody(List<File> files) {
    var sum = 0;

    for (File f in files) {
      if (f.date.isAfter(DateTime.now().subtract(Duration(days: daysToShow))) ||
          daysToShow == 0) {
        sum += f.price;
      }
    }

    return Text('Total sum: ' + sum.toString());
  }

  SingleChildScrollView expenseList(List<File> files) {
    final List<DataRow> dataRows = [];

    for (File f in files) {
      if (f.date.isAfter(DateTime.now().subtract(Duration(days: daysToShow))) ||
          daysToShow == 0) {
        dataRows.add(DataRow(cells: <DataCell>[
          DataCell(Text(f.title), onLongPress: () {
            setState(() {
              DbHelper.deleteFile(f);
            });
          }),
          DataCell(Text(f.category)),
          DataCell(Text(
              '${f.date.day.toString()}-${f.date.month.toString()}-${f.date.year.toString()}')),
          DataCell(Text(f.price.toString()))
        ]));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
          columnSpacing: 30.0,
          sortColumnIndex: 0,
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Price')),
          ],
          rows: dataRows),
    );
  }

  Column categoryPriceList(List<File> files) {
    var listOfCategories = {};
    for (File f in files) {
      if (f.date.isAfter(DateTime.now().subtract(Duration(days: daysToShow))) ||
          daysToShow == 0) {
        if (listOfCategories.containsKey(f.category)) {
          listOfCategories.update(
              f.category, (value) => f.price + listOfCategories[f.category]);
        } else {
          listOfCategories[f.category] = f.price;
        }
      }
    }

    return Column(
        children: listOfCategories.entries
            .map((e) => Text('${e.key}: ${e.value}'))
            .toList());
  }
}

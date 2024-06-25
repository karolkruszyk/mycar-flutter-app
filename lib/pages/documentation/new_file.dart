import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mycar/pages/documentation/file.dart';

import '../db_helper.dart';

class NewFile extends StatefulWidget {
  const NewFile({Key? key}) : super(key: key);

  @override
  State<NewFile> createState() => NewFileState();
}

class NewFileState extends State<NewFile> {
  var category = '';
  var title = '';
  var price = 0;
  bool _validate = false;
  late DateTime selectedDate = DateTime.now();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          child: Text('Insurance'), value: 'Insurance'),
      const DropdownMenuItem(child: Text('Technical inspection'), value: 'Technical inspection'),
      const DropdownMenuItem(
        child: Text('Vehicle equipment'),
        value: 'Vehicle equipment',
      ),
      const DropdownMenuItem(child: Text('Repair'), value: 'Repair'),
      const DropdownMenuItem(child: Text('Fuel'), value: 'Fuel'),
      const DropdownMenuItem(child: Text('Parking'), value: 'Parking'),
      const DropdownMenuItem(child: Text('Car wash'), value: 'Car wash'),
      const DropdownMenuItem(
          child: Text('Consumable parts'), value: 'Consumable parts'),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an expense'),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                    isExpanded: true,
                    value:
                        category.isEmpty ? dropdownItems.first.value : category,
                    items: dropdownItems,
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          category = newValue.toString();
                        },
                      );
                    }),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Title',
                      errorText:
                          _validate && title.isEmpty ? 'Insert the title!' : null),
                  onChanged: (titleInput) {
                    setState(() {
                      log(titleInput);
                      title = titleInput;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Price',
                      errorText:
                          _validate && price <= 0 ? 'Insert the price!' : null),
                  onChanged: (priceInput) {
                    setState(() {
                      if (int.tryParse(priceInput) != null) {
                        price = int.parse(priceInput);
                      } else {
                        _validate = false;
                      }
                    });
                  },
                ),
                ElevatedButton(
                    child: Text(
                        '${selectedDate.day.toString()}-${selectedDate.month.toString()}-${selectedDate.year.toString()}'),
                    onPressed: () {
                      showDatePicker(
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 1500)),
                              context: context)
                          .then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      });
                    }),
                const SizedBox(
                  height: 50.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (title.isEmpty || price <= 0) {
                        setState(() {
                          _validate = true;
                        });
                      } else {
                        File f = File(
                            category: category.isEmpty
                                ? dropdownItems.first.value.toString()
                                : category,
                            title: title,
                            date: selectedDate,
                            price: price);

                        await DbHelper.addFile(f);
                        Navigator.pop(context);
                      }
                    },
                    onLongPress: () async {
                      List<File>? a = await DbHelper.getAllFiles();
                      for (File e in a!) {
                        DbHelper.deleteFile(e);
                      }
                    },
                    child: const Text('Save')),
              ],
            )),
      ),
    );
  }
}

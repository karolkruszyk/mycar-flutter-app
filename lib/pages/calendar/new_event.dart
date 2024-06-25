import 'package:flutter/material.dart';
import 'package:mycar/pages/calendar/event.dart';

import '../db_helper.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => NewEventState();
}

class NewEventState extends State<NewEvent> {
  var category = '';
  var title = '';
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
      const DropdownMenuItem(
          child: Text('Consumable parts'), value: 'Consumable parts'),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan an event'),
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
                      errorText: _validate ? 'Insert the title!' : null),
                  onChanged: (titleInput) {
                    setState(() {
                      title = titleInput;
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
                      if (title.isEmpty) {
                        setState(() {
                          _validate = true;
                        });
                      } else {
                        Event e = Event(
                            category: category.isEmpty
                                ? dropdownItems.first.value.toString()
                                : category,
                            title: title,
                            date: selectedDate);

                        await DbHelper.addEvent(e);
                        Navigator.pop(context);
                      }
                    },
                    onLongPress: () async {
                      List<Event>? a = await DbHelper.getAllEvents();
                      for (Event e in a!) {
                        DbHelper.deleteEvent(e);
                      }
                    },
                    child: const Text('Save')),
              ],
            )),
      ),
    );
  }
}

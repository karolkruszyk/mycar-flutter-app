import 'package:flutter/material.dart';
import 'package:mycar/pages/calendar/event.dart';
import 'package:mycar/pages/calendar/new_event.dart';
import 'package:mycar/pages/db_helper.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool reload = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
        ),
        body: FutureBuilder(
            future: DbHelper.getAllEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Center(child: dataBody(snapshot.data));
              }
              return Center();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewEvent();
            })).then((value) => setState(() {
                  reload = false;
                }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  SingleChildScrollView dataBody(List<Event> events) {
    final List<DataRow> dataRows = [];

    for (Event e in events) {
      dataRows.add(DataRow(cells: <DataCell>[
        DataCell(Text(e.title), onLongPress: () {
          setState(() {
            DbHelper.deleteEvent(e);
          });
        }),
        DataCell(Text(e.category)),
        DataCell(Text(
            '${e.date.day.toString()}-${e.date.month.toString()}-${e.date.year.toString()}')),
      ]));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
          sortColumnIndex: 0,
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Date')),
          ],
          rows: dataRows),
    );
  }
}

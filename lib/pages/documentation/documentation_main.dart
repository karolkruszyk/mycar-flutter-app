import 'package:flutter/material.dart';
import 'package:mycar/pages/db_helper.dart';
import 'package:mycar/pages/documentation/file.dart';
import 'package:mycar/pages/documentation/new_file.dart';

class DocumentationPage extends StatefulWidget {
  @override
  _DocumentationPageState createState() => _DocumentationPageState();
}

class _DocumentationPageState extends State<DocumentationPage> {
  bool reload = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Documentation'),
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
                return Center(child: dataBody(snapshot.data));
              }
              return Center();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewFile();
            })).then((value) => setState(() {
                  reload = false;
                }));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  SingleChildScrollView dataBody(List<File> files) {
    final List<DataRow> dataRows = [];

    for (File f in files) {
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
}

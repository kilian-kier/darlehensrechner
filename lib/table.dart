import 'package:flutter/material.dart';

import 'calculator.dart';
import 'data.dart';

class TableView extends StatefulWidget {
  const TableView({super.key});

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final rows = <TableRow>[];

  @override
  void initState() {
    rows.add(TableRow(children: const [
      SizedBox(
          height: 60,
          child: Center(
              child: Text(
            "Monat",
            textScaleFactor: 1.5,
          ))),
      Center(
          child: Text(
        "Restschulden",
        textScaleFactor: 1.5,
      )),
      Center(
          child: Text(
        "Rate",
        textScaleFactor: 1.5,
      )),
      Center(
          child: Text(
        "Zinsanteil",
        textScaleFactor: 1.5,
      )),
      Center(
          child: Text(
        "Tilgungsanteil",
        textScaleFactor: 1.5,
      ))
    ], decoration: BoxDecoration(color: Colors.black.withAlpha(40))));

    for (var monatData in Data.dataTable) {
      rows.add(TableRow(children: [
        SizedBox(
            height: 40, child: Center(child: Text(monatData.monat.toString()))),
        Center(child: Text(Calculator.doubleToEuro(monatData.restschulden))),
        Center(child: Text(Calculator.doubleToEuro(monatData.rate))),
        Center(child: Text(Calculator.doubleToEuro(monatData.zinsanteil))),
        Center(child: Text(Calculator.doubleToEuro(monatData.tilgungsanteil)))
      ]));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Data.dataTable.isEmpty) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.all(15),
        child: Container(),
      );
    } else {
      return Card(
          elevation: 5,
          margin: const EdgeInsets.all(15),
          child: Scrollbar(
              radius: const Radius.circular(20),
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Table(
                    border: TableBorder.all(color: Colors.grey.shade500),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: rows),
              )));
    }
  }
}

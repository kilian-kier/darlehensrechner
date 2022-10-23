import 'package:flutter/material.dart';

class Data {
  static List<RowData> dataTable = [];

  static var darlehensController = TextEditingController();
  static var zinssatzController = TextEditingController();
  static var dauerController = TextEditingController();
  static var gesamtzinsenController = TextEditingController();
  static var rateController = TextEditingController();
}

class RowData {
  int monat;
  double restschulden;
  double rate;
  double zinsanteil;
  double tilgungsanteil;

  RowData(this.monat, this.restschulden, this.rate, this.zinsanteil,
      this.tilgungsanteil);
}

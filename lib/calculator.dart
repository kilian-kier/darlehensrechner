import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'data.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  static double euroToDouble(String str) {
    var s = str
        .substring(0, str.length - 2)
        .replaceAll(".", "")
        .replaceAll(",", ".");
    return double.parse(s);
  }

  static String doubleToEuro(double d) {
    return NumberFormat.simpleCurrency(locale: 'de-IT', decimalDigits: 2)
        .format(d);
  }

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _formKey = GlobalKey<FormState>();

  bool isValid() {
    if (Data.darlehensController.text.isNotEmpty &&
        Data.dauerController.text.isNotEmpty &&
        Data.zinssatzController.text.isNotEmpty) {
      return true;
    } else if (Data.darlehensController.text.isNotEmpty &&
        Data.dauerController.text.isNotEmpty &&
        Data.rateController.text.isNotEmpty) {
      return true;
    } else if (Data.darlehensController.text.isNotEmpty &&
        Data.zinssatzController.text.isNotEmpty &&
        Data.rateController.text.isNotEmpty) {
      return true;
    } else if (Data.dauerController.text.isNotEmpty &&
        Data.zinssatzController.text.isNotEmpty &&
        Data.rateController.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  void variant1() {
    double darlehen = Calculator.euroToDouble(Data.darlehensController.text);
    double darlehenCopy = darlehen;
    double dauer =
        double.parse(Data.dauerController.text.replaceAll(" Monate", ""));
    double zinssatz = double.parse(
        Data.zinssatzController.text.replaceAll(",", ".").replaceAll("%", ""));

    double KWF = (pow(1.0 + zinssatz / 1200.0, dauer) * zinssatz / 1200.0) /
        (pow(1.0 + zinssatz / 1200.0, dauer) - 1.0);
    double rate = darlehen * KWF;

    Data.rateController.text =
        NumberFormat.simpleCurrency(locale: 'de-IT', decimalDigits: 2)
            .format(rate);

    int monat = 1;

    while (true) {
      double zinsanteil = zinssatz / 100.0 * darlehen / 12.0;
      double tilgungsanteil = rate - zinsanteil;

      if (tilgungsanteil > darlehen) {
        tilgungsanteil = darlehen;
        rate = tilgungsanteil + zinsanteil;
      }

      darlehen -= tilgungsanteil;

      var r = RowData(monat, darlehen, rate, zinsanteil, tilgungsanteil);
      Data.dataTable.add(r);
      monat++;

      if (darlehen == 0) break;
    }

    monat--;

    double sum = 0;

    for (var x in Data.dataTable) {
      sum += x.rate;
    }

    sum -= darlehenCopy;

    var gesamtzinsen = Calculator.doubleToEuro(sum);

    Data.gesamtzinsenController.text = gesamtzinsen;
  }

  void variant2() {
    double darlehen = Calculator.euroToDouble(Data.darlehensController.text);
    double dauer =
        double.parse(Data.dauerController.text.replaceAll(" Monate", ""));
    double rate = Calculator.euroToDouble(Data.rateController.text);

    double gesamtaufwand = rate * dauer;
    double gesamtzinsen = gesamtaufwand - darlehen;

    // while (true) {}
  }

  void variant3() {
    int monat = 1;
    double darlehen = Calculator.euroToDouble(Data.darlehensController.text);
    double darlehenCopy = darlehen;

    double zinssatz = double.parse(
        Data.zinssatzController.text.replaceAll(",", ".").replaceAll("%", ""));
    double rate = Calculator.euroToDouble(Data.rateController.text);

    while (true) {
      double zinsanteil = zinssatz / 100.0 * darlehen / 12.0;
      double tilgungsanteil = rate - zinsanteil;

      if (tilgungsanteil > darlehen) {
        tilgungsanteil = darlehen;
        rate = tilgungsanteil + zinsanteil;
      }

      darlehen -= tilgungsanteil;

      var r = RowData(monat, darlehen, rate, zinsanteil, tilgungsanteil);
      Data.dataTable.add(r);
      monat++;

      if (darlehen == 0) break;
    }

    monat--;

    Data.dauerController.text = '$monat Monate';

    double sum = 0;

    for (var x in Data.dataTable) {
      sum += x.rate;
    }

    sum -= darlehenCopy;

    var gesamtzinsen = Calculator.doubleToEuro(sum);

    Data.gesamtzinsenController.text = gesamtzinsen;
  }

  void variant4() {
    double dauer =
        double.parse(Data.dauerController.text.replaceAll(" Monate", ""));
    double zinssatz = double.parse(
        Data.zinssatzController.text.replaceAll(",", ".").replaceAll("%", ""));
    double rate = Calculator.euroToDouble(Data.rateController.text);

    double inverseKWF = (pow(1.0 + zinssatz / 1200.0, dauer) - 1.0) /
        (pow(1.0 + zinssatz / 1200.0, dauer) * zinssatz / 1200.0);

    double darlehen = inverseKWF * rate;
    Data.darlehensController.text =
        NumberFormat.simpleCurrency(locale: 'de-IT', decimalDigits: 2)
            .format(darlehen);
    double darlehenCopy = darlehen;
    int monat = 1;

    while (true) {
      double zinsanteil = zinssatz / 100.0 * darlehen / 12.0;
      double tilgungsanteil = rate - zinsanteil;

      if (tilgungsanteil > darlehen) {
        tilgungsanteil = darlehen;
        rate = tilgungsanteil + zinsanteil;
      }

      darlehen -= tilgungsanteil;

      var r = RowData(monat, darlehen, rate, zinsanteil, tilgungsanteil);
      Data.dataTable.add(r);
      monat++;

      if (darlehen == 0) break;
    }

    monat--;

    double sum = 0;

    for (var x in Data.dataTable) {
      sum += x.rate;
    }

    sum -= darlehenCopy;

    var gesamtzinsen = Calculator.doubleToEuro(sum);

    Data.gesamtzinsenController.text = gesamtzinsen;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(50),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: TextFormField(
                        controller: Data.darlehensController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          prefixIcon:
                              const Icon(Icons.euro, color: Colors.blue),
                          hintText: "Darlehensbetrag",
                          hintStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                        ),
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                              locale: 'it', decimalDigits: 2, symbol: '€')
                        ],
                        keyboardType: TextInputType.number,
                        validator: (_) {
                          if (!isValid()) {
                            return 'Bitte gib etwas bei min. 3 Felder ein';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          calculate();
                        }),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: TextFormField(
                        controller: Data.dauerController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          prefixIcon:
                              const Icon(Icons.schedule, color: Colors.blue),
                          hintText: "Dauer in Monate",
                          hintStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        validator: (_) {
                          if (!isValid()) {
                            return 'Bitte gib etwas bei min. 3 Felder ein';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          calculate();
                        }),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: TextFormField(
                        controller: Data.zinssatzController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          prefixIcon:
                              const Icon(Icons.percent, color: Colors.blue),
                          hintText: "Zinssatz",
                          hintStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9]+,?[0-9]*")),
                          PercentageTextFormatter()
                        ],
                        keyboardType: TextInputType.number,
                        validator: (_) {
                          if (!isValid()) {
                            return 'Bitte gib etwas bei min. 3 Felder ein';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          calculate();
                        }),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: TextFormField(
                        controller: Data.rateController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          prefixIcon:
                              const Icon(Icons.repeat, color: Colors.blue),
                          hintText: "monatliche Rate",
                          hintStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                        ),
                        inputFormatters: [
                          CurrencyTextInputFormatter(
                              locale: 'it', decimalDigits: 2, symbol: '€')
                        ],
                        keyboardType: TextInputType.number,
                        validator: (_) {
                          if (!isValid()) {
                            return 'Bitte gib etwas bei min. 3 Felder ein';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          calculate();
                        }),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 15.0)),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: TextFormField(
                      controller: Data.gesamtzinsenController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          prefixIcon:
                              const Icon(Icons.money, color: Colors.blue),
                          hintText: "Gesamtzinsen",
                          hintStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          enabled: false),
                    ),
                  )
                ],
              )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Data.dataTable.clear();
                          Data.darlehensController.clear();
                          Data.dauerController.clear();
                          Data.zinssatzController.clear();
                          Data.rateController.clear();
                          Data.gesamtzinsenController.clear();
                        },
                        child: const Text('Löschen'),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 25)),
                      ElevatedButton(
                        onPressed: () {
                          calculate();
                        },
                        child: const Text('Berechnen'),
                      )
                    ],
                  )),
            ],
          )),
    );
  }

  void calculate() {
    Data.dataTable.clear();

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Berechne...'),
            duration: Duration(milliseconds: 300)),
      );
    }

    if (Data.darlehensController.text.isNotEmpty &&
        Data.dauerController.text.isNotEmpty &&
        Data.zinssatzController.text.isNotEmpty) {
      variant1();
    } else if (Data.darlehensController.text.isNotEmpty &&
        Data.dauerController.text.isNotEmpty &&
        Data.rateController.text.isNotEmpty) {
      variant2();
    } else if (Data.darlehensController.text.isNotEmpty &&
        Data.zinssatzController.text.isNotEmpty &&
        Data.rateController.text.isNotEmpty) {
      variant3();
    } else if (Data.dauerController.text.isNotEmpty &&
        Data.zinssatzController.text.isNotEmpty &&
        Data.rateController.text.isNotEmpty) {
      variant4();
    }
  }
}

class PercentageTextFormatter extends TextInputFormatter {
  String addPercentSign(String value) {
    if (value.trim().isEmpty) return "";
    if (value.contains("%")) return value;
    return '$value%';
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: addPercentSign(newValue.text),
      selection: newValue.selection,
    );
  }
}

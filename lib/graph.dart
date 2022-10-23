import 'package:darlehensrechner/data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<LineChartBarData> data = [
    LineChartBarData(spots: [], color: Colors.blue),
    LineChartBarData(spots: [], color: Colors.red),
    LineChartBarData(spots: [], color: Colors.yellow),
    LineChartBarData(spots: [], color: Colors.green)
  ];

  @override
  void initState() {
    double ratenSum = 0;
    double zinsSum = 0;
    double tilgungsSum = 0;
    for (var monthData in Data.dataTable) {
      data[0]
          .spots
          .add(FlSpot(monthData.monat.toDouble(), monthData.restschulden));

      ratenSum += monthData.rate;
      data[1].spots.add(FlSpot(monthData.monat.toDouble(), ratenSum));

      zinsSum += monthData.zinsanteil;
      data[2].spots.add(FlSpot(monthData.monat.toDouble(), zinsSum));

      tilgungsSum += monthData.tilgungsanteil;
      data[3].spots.add(FlSpot(monthData.monat.toDouble(), tilgungsSum));
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
      int maxMonth = Data.dataTable[Data.dataTable.length - 1].monat;
      return Column(
        children: [
          Expanded(
              child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(15),
                  child: LineChart(LineChartData(
                      minX: 0,
                      minY: 0,
                      maxX: maxMonth.toDouble(),
                      maxY: Data.dataTable[0].rate * maxMonth,
                      lineBarsData: data)))),
          SizedBox(
            width: 200,
            height: 150,
            child: Card(
              elevation: 5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      children: const [
                        Icon(Icons.circle, color: Colors.blue),
                        Text("    Restschulden")
                      ],
                    ),
                    Wrap(
                      children: const [
                        Icon(Icons.circle, color: Colors.red),
                        Text("    Gesamtaufwand")
                      ],
                    ),
                    Wrap(
                      children: const [
                        Icon(Icons.circle, color: Colors.green),
                        Text("    Tilgungsanteil")
                      ],
                    ),
                    Wrap(
                      children: const [
                        Icon(Icons.circle, color: Colors.yellow),
                        Text("    Zinsanteil")
                      ],
                    )
                  ]),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 50))
        ],
      );
    }
  }
}

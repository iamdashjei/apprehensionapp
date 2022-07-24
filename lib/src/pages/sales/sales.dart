import 'package:date_utils/date_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:pnpdict/src/charts/date_time_line_point.dart';
import 'package:pnpdict/src/models/time_series_sales_model.dart';
import 'package:pnpdict/src/util/hex_color.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pnpdict/src/util/indicator.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

import '../../util/calendar.dart';
/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class EventDate {

  /// Event's date.
  final DateTime date;

  /// Event's title.
  final String dis;

  ///
  EventDate(this.date, this.dis)
      : assert(date != null),
        assert(dis != null);
}

class SalesPage extends StatefulWidget {

  const SalesPage({Key key}) : super(key: key);
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>{
  List<charts.Series> seriesList = new List();
  bool animate = false;
  int touchedIndex;

  final DateRangePickerController _controller = DateRangePickerController();
  final formatter = new NumberFormat("#,##0.00#", "en_US");

  DateTime _selectedDate = DateTime.now();
  List<EventDate> events;
  bool isAllSelected = true, isDaySelected = false, isMonthSelected = false, isYearSelected = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildDayTableCalendar(){

    return Container(
      child: SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.multiple,
      ),
    );
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).dividerColor),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  Widget _getSimpleChar(){
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '2AM';
              case 2:
                return '2AM';
              case 3:
                return '2AM';
              case 4:
                return '2AM';
              case 5:
                return '2AM';
              case 6:
                return '2AM';
              case 7:
                return '2AM';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '500.00';
              case 2:
                return '1,000.00';
              case 3:
                return '1,500.00';
              case 4:
                return '2,000.00';
              case 5:
                return '2,500.00';
              case 6:
                return '3,000.00';
              case 7:
                return '3,500.00';
            }
            return '';
          },
          margin: 10,
          reservedSize: 50,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 7,
      maxY: 8,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(2, 2),
        FlSpot(3, 3),
        FlSpot(4, 4),
        FlSpot(5, 5),
        FlSpot(6, 6),
        FlSpot(7, 7),
      ],
      isCurved: true,
      colors: [
        Colors.deepOrangeAccent,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(7, 2),
        FlSpot(6, 3),
        FlSpot(5, 4),
        FlSpot(4, 1),
        FlSpot(3, 3),
        FlSpot(2, 2),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 7),
        FlSpot(2, 2),
        FlSpot(3, 3),
        FlSpot(4, 5),
        FlSpot(5, 4),
      ],
      isCurved: true,
      colors:  [
        Colors.blueAccent,
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }

  Widget showPieChart(){
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        margin: EdgeInsets.all(10.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              child: Text("Category", style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: MediaQuery.of(context)
                      .textScaleFactor *
                      18),),
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20,),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Indicator(
                      color: Color(0xff0293ee),
                      text: 'Apprehended',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      text: 'Settled',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff27e730),
                      text: 'Cleared',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xffff0000),
                      text: 'Unsettled',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                  pieTouchResponse.touchInput is! PointerUpEvent;
                              if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                touchedIndex = pieTouchResponse.touchedSectionIndex;
                              } else {
                                touchedIndex = -1;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 4,
                          centerSpaceRadius: 0,
                          sections: showingSections()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 16;
      final double radius = isTouched ? 60 : 50;
      final double widgetSize = isTouched ? 55 : 40;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: null,
            badgePositionPercentageOffset: .30,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: null,
            badgePositionPercentageOffset: .30,
          );
        default:
          return null;
      }
    });
  }

  showDayAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        setState(() {
          isAllSelected = false;
          isDaySelected = true;
          isMonthSelected = false;
          isYearSelected = false;
        });
        Navigator.of(context).pop();
      },
    );

    // set up the button
    Widget cancel = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = new AlertDialog(
      title: Text("Filter by Day"),
      content: SingleChildScrollView(
        child: Container(
          height: 300,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildDayTableCalendar(),
            ],
          ),
        ),
      ),
      actions: [
        cancel,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showMonthAlertDialog(BuildContext context) {

    dp.DatePickerStyles styles = dp.DatePickerStyles(
        selectedDateStyle: Theme.of(context)
            .accentTextTheme
            .bodyText1
            ?.copyWith(color: Colors.white),
        selectedSingleDateDecoration: BoxDecoration(
            color: Colors.blueAccent, shape: BoxShape.circle));
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        setState(() {
          isAllSelected = false;
          isDaySelected = false;
          isMonthSelected = true;
          isYearSelected = false;
        });
        Navigator.of(context).pop();
      },
    );

    // set up the button
    Widget cancel = new FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = new AlertDialog(
      title: Text("Filter by Month"),
      content:  new SingleChildScrollView(
        child: Container(
          height: 300,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: dp.MonthPicker(
                  selectedDate: _selectedDate,
                  onChanged: _onSelectedDateChanged,
                  firstDate: kFirstDay,
                  lastDate: kLastDay,
                  datePickerStyles: styles,
                ),
              ),
              //buildMonthTableCalendar(),
            ],
          ),
        ),
      ),
      actions: [
        cancel,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showYearAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the button
    Widget cancel = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Filter by Year"),
      content: SingleChildScrollView(
        child: Container(
          height: 300,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
             // buildYearTableCalendar(),
            ],
          ),
        ),
      ),
      actions: [
        cancel,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: HexColor("#ECECEC"),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: isAllSelected == true ? HexColor("#0C9E1F") : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: isAllSelected == true ? HexColor("#0C9E1F") : HexColor("#373737"))),
                    onPressed: () {
                      print("Clicked");
                      setState(() {
                        isAllSelected = true;
                        isDaySelected = false;
                        isMonthSelected = false;
                        isYearSelected = false;
                      });

                    },
                    child: Text(
                      "All",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isAllSelected == true ? Colors.white : Colors.black,
                          fontSize: MediaQuery.of(context)
                              .textScaleFactor *
                              14),
                    ),
                  ),
                  RaisedButton(
                    color: isDaySelected == true ? HexColor("#0C9E1F") : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: isDaySelected == true ? HexColor("#0C9E1F") : HexColor("#373737"))),
                    onPressed: () {

                      showDayAlertDialog(context);
                    },
                    child: Text(
                      "Day",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDaySelected == true ? Colors.white : Colors.black,
                          fontSize: MediaQuery.of(context)
                              .textScaleFactor *
                              14),
                    ),
                  ),RaisedButton(
                    padding: EdgeInsets.zero,
                    color: isMonthSelected == true ? HexColor("#0C9E1F") : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: isMonthSelected == true ? HexColor("#0C9E1F") : HexColor("#373737"))),
                    onPressed: () {
                      // MonthPicker(selectedDate: null,
                      //     onChanged: null,
                      //     firstDate: kFirstDay,
                      //     lastDate: kLastDay);
                      showMonthAlertDialog(context);

                    },
                    child: Text(
                      "Month",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMonthSelected == true ? Colors.white : Colors.black,
                          fontSize: MediaQuery.of(context)
                              .textScaleFactor *
                              14),
                    ),
                  ),
                  RaisedButton(
                    color: isYearSelected == true ? HexColor("#0C9E1F") : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: isYearSelected == true ? HexColor("#0C9E1F") : HexColor("#373737"))),
                    onPressed: () async {

                      DateTime newSelectedDate = await showDatePicker(context: context, initialDatePickerMode: DatePickerMode.year,
                          initialDate: DateTime.now(),
                          firstDate: kFirstDay,
                          lastDate: kLastDay);

                      if(newSelectedDate != null){
                        setState(() {
                          isAllSelected = false;
                          isDaySelected = false;
                          isMonthSelected = false;
                          isYearSelected = true;
                        });
                      }
                    },
                    child: Text(
                      "Year",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isYearSelected == true ? Colors.white : Colors.black,
                          fontSize: MediaQuery.of(context)
                              .textScaleFactor *
                              14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text("Apprehension", style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            15),),
                  ),
                  Container(
                    child: Text(formatter.format(0), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context)
                            .textScaleFactor *
                            50),),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(thickness: 2, endIndent: 10, indent: 10,),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text("Cancelled", style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                15),),
                      ),
                      Container(
                        child: Text(formatter.format(0), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                35),),
                      ),
                      Container(
                        child: Text("(P"+ formatter.format(0) +")", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                15),),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  //SizedBox(width: 100),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text("Unsettled", style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                15),),
                      ),
                      Container(
                        child: Text("0", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                35),),
                      ),
                      Container(
                        child: Text("(P"+ formatter.format(0) +")", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                15),),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text("Cleared", style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                15),),
                      ),
                      Container(
                        child: Text("0", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                35),),
                      ),
                      Container(
                        child: Text("(P"+ formatter.format(0) +")", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context)
                                .textScaleFactor *
                                15),),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              _getSeparator(15),
              Card(
                margin: EdgeInsets.all(10.0),
                color: Colors.white,
                shadowColor: Colors.grey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      child: Text("Apprehension Volume", style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: MediaQuery.of(context)
                              .textScaleFactor *
                              18),),
                    ),
                    Container(
                      height:400,
                      width: 450,
                      margin: EdgeInsets.all(20.0),
                      // child: LineChart(
                      //   sampleData1(),
                      //   swapAnimationDuration: const Duration(milliseconds: 250),
                      // ),
                      child: DateTimeComboLinePointChart(_createSampleData()),
                    ),
                  ],
                )

              ),
              _getSeparator(15),
              showPieChart(),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
  }

  void _onSelectedDateChanged(DateTime newDate) {
    print("Changing month");
    setState(() {
      _selectedDate = newDate;
    });
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final desktopSalesData = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 0),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 0),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 0),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 0),
    ];

    final tableSalesData = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 0),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 0),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 0),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 0),
    ];

    final mobileSalesData = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 0),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 0),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 0),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 0),
    ];

    return [
      // new charts.Series<TimeSeriesSales, DateTime>(
      //   id: 'Desktop',
      //   colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      //   domainFn: (TimeSeriesSales sales, _) => sales.time,
      //   measureFn: (TimeSeriesSales sales, _) => sales.sales,
      //   data: desktopSalesData,
      // ),
      // new charts.Series<TimeSeriesSales, DateTime>(
      //   id: 'Tablet',
      //   colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      //   domainFn: (TimeSeriesSales sales, _) => sales.time,
      //   measureFn: (TimeSeriesSales sales, _) => sales.sales,
      //   data: tableSalesData,
      // ),
      // new charts.Series<TimeSeriesSales, DateTime>(
      //     id: 'Mobile',
      //     colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      //     domainFn: (TimeSeriesSales sales, _) => sales.time,
      //     measureFn: (TimeSeriesSales sales, _) => sales.sales,
      //     data: mobileSalesData)
      // // Configure our custom point renderer for this series.
      //   ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }



}



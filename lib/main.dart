import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calcLogic.dart';

void main() => runApp(new TipCalculator());

final calculatorState = new _CalculatorState();

class TipCalculator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        sliderTheme: new SliderThemeData(
            overlayColor: Colors.black,
            valueIndicatorColor: Colors.black,
            valueIndicatorTextStyle: TextStyle(),
            valueIndicatorShape: new PaddleSliderValueIndicatorShape(),
            showValueIndicator: ShowValueIndicator.always,
            activeTrackColor: Colors.black,
            activeTickMarkColor: Colors.transparent,
            disabledActiveTrackColor: Colors.black87,
            disabledActiveTickMarkColor: Colors.black87,
            disabledInactiveTrackColor: Colors.black87,
            disabledThumbColor: Colors.black87,
            thumbColor: Colors.black,
            thumbShape: new RoundSliderThumbShape(),
            disabledInactiveTickMarkColor: Colors.transparent,
            inactiveTrackColor: Colors.grey,
            inactiveTickMarkColor: Colors.grey),
      ),
      home: new CalculatorPage(title: 'Split the Bill!'),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _CalculatorState createState() => calculatorState;
}

class _CalculatorState extends State<CalculatorPage> {
  final numFormat = new NumberFormat("#,##0.00", "en_US");
  CalcNumber calcNumber = new CalcNumber();
  bool result = false;
  double tip = 0.0;
  double friends = 0.0;
  double amountPerPerson = 0.0;

  double billAmount() {
    var temp = calcNumber.queueToString();
    return double.parse(temp) / 100;
  }

  double tipAmount() {
    return billAmount() * tip / 100.0;
  }

  double totalAmount() {
    return (billAmount() + tipAmount());
  }

  void splitBill() {
    setState((){
    var dollars = totalAmount().toString().split('.');
    print(friends);
    amountPerPerson =
        friends != 0.0 ? (totalAmount() / (friends + 1)) : totalAmount();
    var round = dollars[1].length;
    if (round >= 2) amountPerPerson += .01;
    print(amountPerPerson);
    });
  }

  bool tipSelected(String tipPct) {
    return tipPct == "${tip.toStringAsPrecision(2)}";
  }

  Color tipButtonCollor(String tipPct) {
    return tipSelected(tipPct) ? Colors.green : Colors.grey;
  }

  void addNumberToBill(Object number) {
    if (calcNumber.queue.length + 1 >= 7 && number is int) {
      // Good place to add a dialog to explain why its not entering
      return;
    }
    if (number is int) {
      if (calcNumber.queueToString() == "000" && number == 0) return;
      calcNumber.addNumber(number);
    } else {
      if (number == Icons.backspace)
        calcNumber.removeNumber();
      else {
        calcNumber.clearQueue();
      }
    }
    splitBill();
  }

  void sliderUpdated(double value) {
    setState(() {
      friends = value;
    });
    splitBill();
  }

  @override
  Widget build(BuildContext context) {
    // Builds the slider for splitting the check
    Stack buildSlider() {
      return new Stack(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(top: 35.0, bottom: 25.0),
            child: new Slider(
              key: new Key("FriendsSlider"),
              value: friends,
              max: 10.0,
              min: 0.0,
              divisions: 10,
              onChanged: (double value) => sliderUpdated(value),
              label: friends == 0 ? "Just me!" : "$friends friend(s)!",
            ),
          )
        ],
      );
    }

    // Builds the button to select tip percentage
    Widget buildTipButton(String pct) {
      return new MaterialButton(
        color: tipButtonCollor(pct),
        child: new Text(
          "$pct%",
          style: new TextStyle(
            fontWeight: tipSelected(pct) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onPressed: () {
          setState(() {
            if (tip != double.parse(pct))
              tip = double.parse(pct);
            else
              tip = 0.0;
          });
        },
      );
    }

    // Builds the row containing tip buttons
    // Any four (or more) numberes could be passed here depending on screen size i.e. 15, 18, 20, 25
    Container buildTipRow() {
      return new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildTipButton("15"),
            buildTipButton("18"),
            buildTipButton("20"),
            buildTipButton("25"),
          ],
        ),
      );
    }

    // Builds Top Container to hold total, tip, per person, and bill ammount
    Row buildTopContent() {
      return new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Column for Bill Ammount
              new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "BILL \$",
                      style: new TextStyle(fontSize: 12.0, color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    new Text(
                      numFormat.format(billAmount()),
                      style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Column for Tip Ammount
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "TIP \$",
                    style: new TextStyle(fontSize: 12.0, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  new Text(
                    numFormat.format(tipAmount()),
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Column for Total Ammount
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "TOTAL \$",
                    style: new TextStyle(fontSize: 12.0, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  new Text(
                    numFormat.format(totalAmount()),
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Column for Amount per person
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "Per/Person \$",
                    style: new TextStyle(fontSize: 12.0, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  new Text(
                    numFormat.format(amountPerPerson),
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
    }

    // Builds the top "Card". While there is a material design widget called card
    // this is using a Container to allow Gradient support
    Container buildTopContainer() {
      return new Container(
          margin: new EdgeInsets.only(top: 10.0),
          padding: new EdgeInsets.symmetric(vertical: 35.0, horizontal: 15.0),
          color: Colors.black,
          child: buildTopContent());
    }

    // Builds buttons of calculator
    // Creates a raised button but can also use flat buttons depending on style desired
    Container buildCalculatorButton(Object buttonText) {
      return new Container(
          // Conditional to determine style of button
          child: buttonText is String
              ? // Case when text for a button is a number 0-9
              new RaisedButton(
                  key: new Key(buttonText),
                  onPressed: () => setState(() {
                        addNumberToBill(int.parse(buttonText));
                      }),
                  child: new Text(
                    buttonText,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                )
              : // Case when text for a button is an icon
              new RaisedButton(
                  onPressed: calcNumber.queueToString() != "000"
                      ? () => setState(() {
                            addNumberToBill(buttonText);
                          })
                      : null,
                  child: new Icon(buttonText,
                      size: 20.0,
                      color: calcNumber.queueToString() != "000"
                          ? Colors.red
                          : Colors.grey),
                ));
    }

    // Builds the botton rows for the calculator.
    // Takes in three icons/numbers and returns a button bar containing them
    Container buildButtonRow(List<Object> items) {
      return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: new ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCalculatorButton(items[0]),
            buildCalculatorButton(items[1]),
            buildCalculatorButton(items[2])
          ],
        ),
      );
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new ListView(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: <Widget>[
            new Column(
              // Column is also layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug paint" (press "p" in the console where you ran
              // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
              // window in IntelliJ) to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Top Container
                new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: buildTopContainer(),
                ),

                // Slider for splitting the check
                new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: buildSlider(),
                ),

                // Tip row for setting tip percentages
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                  child: buildTipRow(),
                ),

                // Builds rows of buttons for calculator
                buildButtonRow(["1", "2", "3"]),
                buildButtonRow(["4", "5", "6"]),
                buildButtonRow(["7", "8", "9"]),
                buildButtonRow([Icons.cancel, "0", Icons.backspace]),
              ],
            ),
          ]),
    );
  }
}

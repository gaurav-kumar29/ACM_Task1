import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coffee App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _textController = new TextEditingController();
  static bool valuefirst = false;
  static bool valuesecond = false;
  static int _n = 0;
  String enteredText;

  @override
  Widget build(BuildContext context) {
    double cost;
    double qty = double.parse((_n).toString());
    cost = qty*14.00;
    return new Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Coffee App'),
        ),
        body: Center(
          child: SafeArea(
            child: Column(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  new ListTile(
                    title: new TextField(
                      decoration: new InputDecoration.collapsed(
                          hintText: 'Name'
                      ),
                      controller: _textController,
                      onChanged: (String newText) { enteredText = newText; },
                    ),
                  ),
                  Spacer(),
                  Center(child: Text('Toppings',style: TextStyle(fontSize: 26),)),
                  CheckboxListTile(
                    title: const Text('Whipped Cream'),
                    value: valuefirst,
                    onChanged: (bool value) {
                      setState(() {
                        valuefirst = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: const Text('Chocolate'),
                    value: valuesecond,
                    onChanged: (bool value) {
                      setState(() {
                        valuesecond = value;
                      });
                    },
                  ),
                  Spacer(),
                  Center(child: Text('Quantity',style: TextStyle(fontSize: 26),)),
                  new Container(
                    child: new Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FloatingActionButton(
                            onPressed: minus,
                            child: new Icon(Icons.remove, color: Colors.black,),
                            backgroundColor: Colors.white,),

                          new Text('$_n',
                              style: new TextStyle(fontSize: 60.0)),

                          new FloatingActionButton(
                            onPressed: add,
                            child: new Icon(Icons.add, color: Colors.black,),
                            backgroundColor: Colors.white,),
                        ],
                      ),
                    ),
                  ),

                  Spacer(),
                  new ListTile(
                    title: new RaisedButton(
                      child: new Text("ORDER"),
                      onPressed: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new NextPage(value: _textController.text),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                  ),
                  new ListTile(
                    title: new RaisedButton(
                      child: new Text("RESET"),
                      onPressed: () {
                        clearText();
                      },
                    ),
                  ),
                  new ListTile(
                    title: new RaisedButton(
                      child: new Text("EMAIL ORDER"),
                      onPressed: () {
                        if(_n==0)
                          _launchURL('example@gmail.com', 'Order Summary', 'Name: $enteredText, Quantity: $_n, Total: \$*0.00');
                        if(_n!=0 && valuefirst==true && valuesecond==true)
                          _launchURL('example@gmail.com', 'Order Summary', 'Name: $enteredText, +Whipped Cream, +Chocolate, Quantity: $_n, Total: \$$cost');
                        if(_n!=0 && valuefirst==true && valuesecond==false)
                          _launchURL('example@gmail.com', 'Order Summary', 'Name: $enteredText, +Whipped Cream, Quantity: $_n, Total: \$$cost');
                        if(_n!=0 && valuefirst==false && valuesecond==true)
                          _launchURL('example@gmail.com', 'Order Summary', 'Name: $enteredText, +Chocolate, Quantity: $_n, Total: \$$cost');
                        if(_n!=0 && valuefirst==false && valuesecond==false)
                          _launchURL('example@gmail.com', 'Order Summary', 'Name: $enteredText, Quantity: $_n, Total: \$$cost');

                      },
                    ),
                  ),
                ]
            )
        )
        )
    );
  }
  void add() {
    setState(() {
      _n++;
    });
  }
  void minus() {
    setState(() {
      if (_n != 0)
        _n--;
    });
  }
  void clearText() {
    _textController.clear();
    valuefirst = false;
    valuesecond = false;
    setState(() => _n = 0);
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class NextPage extends StatefulWidget {
  final String value;
  int cost;


  NextPage({Key key, this.value}) : super(key: key);

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {

  @override
  Widget build(BuildContext context) {
    double cost;
    double qty = double.parse((_MyHomePageState._n).toString());
    cost = qty*14.00;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Order Summary"),
      ),
      body: new ListView(
        children: <Widget>[
          new Text("Name:",style: TextStyle(fontSize: 26),),
          new Text("${widget.value}",style: TextStyle(fontSize: 26),),
          if(_MyHomePageState.valuefirst==true)
            Text('+Whipped Cream',style: TextStyle(fontSize: 26),),
          if(_MyHomePageState.valuesecond==true)
            Text('+Chocolate',style: TextStyle(fontSize: 26),),
          new Text("Quantity:",style: TextStyle(fontSize: 26),),
          new Text("${_MyHomePageState._n}",style: TextStyle(fontSize: 26),),
          if(_MyHomePageState._n==0)
            new Text("Total: \$ 0.00",style: TextStyle(fontSize: 26),),
          if(_MyHomePageState._n!=0)
            new Text("Total: \$ $cost",style: TextStyle(fontSize: 26),),
          new Text("Thank You",style: TextStyle(fontSize: 26),),
        ],
      ),
    );
  }
}

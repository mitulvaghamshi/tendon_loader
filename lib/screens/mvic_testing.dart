import 'package:flutter/material.dart';

import '../bluetooth/bluetooth.dart';

class MVICTesting extends StatefulWidget {
  MVICTesting({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MVICTestingState createState() => _MVICTestingState();
}

class _MVICTestingState extends State<MVICTesting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 16.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.indigo,
                      ),
                    ),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'hero-avater-tag',
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.person,
                            size: 80.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: Text('Profile')),
                            body: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Hero(
                                    child: FlutterLogo(size: 400.0),
                                    tag: 'hero-avater-tag',
                                  ),
                                  Text(
                                    'Hay!, You did it...!!!',
                                    style: Theme.of(context).textTheme.headline4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Bluetooth(
              title: 'Bluetooth',
            ),
          ),
        ),
        tooltip: 'Connect to Bluetooth',
        label: const Text('Connect'),
        icon: Icon(Icons.bluetooth),
      ),
    );
  }
}

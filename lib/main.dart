import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swager_to_dart/helper/shared_preferences_extension.dart';
import 'package:swager_to_dart/src/swager_to_dart_api.dart';
import 'package:swager_to_dart/src/swaget_to_dart_json.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAGER TO DART',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = "";

  String _savePath = "";

  String _template = "";

  TextEditingController urlController;
  TextEditingController templateController;

  @override
  void initState() {
    super.initState();
    SharedPreferencesExtension.windows();
    urlController = TextEditingController();
    templateController = TextEditingController();

    Rx.timer(null, Duration(milliseconds: 200)).listen((event) {
      SharedPreferencesExtension.getTyped<String>("url").then((value) {
        setState(() {
          _url = value;
          urlController.text = value ?? "";
        });
      });
      SharedPreferencesExtension.getTyped<String>("savePath").then((value) {
        setState(() {
          _savePath = value ?? "";
        });
      });
      SharedPreferencesExtension.getTyped<String>("template").then((value) {
        setState(() {
          _template = value;
          templateController.text = value ?? "";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Flexible(
          child: Row(
            children: [
              Text("SWAGER TO DART"),
              SizedBox(width: 16),
              Flexible(
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    hintText: "API URL",
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white54,
                  onChanged: (value) {
                    setState(() {
                      _url = value;
                      SharedPreferencesExtension.setTyped<String>("url", value);
                    });
                  },
                  onSubmitted: _url.isEmpty
                      ? null
                      : (x) => swagerToDartApi(_url, _template, _savePath),
                ),
              )
            ],
          ),
        ),
        actions: [
          FlatButton(
            onPressed: _url.isEmpty
                ? null
                : () {
                    Future.wait([
                      swagerToDartJson(_url, _savePath),
                      swagerToDartApi(_url, _template, _savePath)
                    ]).then((value) {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text("Saved"),
                        ),
                      );
                    });
                  },
            child: Icon(
              Icons.file_download,
              color: _url.isEmpty ? Colors.white54 : Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(_savePath)),
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        showOpenPanel(
                          canSelectDirectories: true,
                        ).then((path) {
                          if (!path.canceled) {
                            setState(() {
                              _savePath = path.paths.first;
                            });

                            SharedPreferencesExtension.setTyped<String>(
                                "savePath", path.paths.first);
                          }
                        });
                      });
                    },
                    child: Text("SAVE PATH"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TEST TEXE"),
                            SizedBox(height: 8),
                            Text(""),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TEMPLATE"),
                            SizedBox(height: 8),
                            Flexible(
                              child: TextField(
                                controller: templateController,
                                decoration: InputDecoration(
                                  hintText: "TEMPLATE",
                                  contentPadding: EdgeInsets.zero,
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                cursorColor: Colors.black54,
                                onChanged: (value) {
                                  _template = value;
                                  SharedPreferencesExtension.setTyped<String>(
                                      "template", value);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

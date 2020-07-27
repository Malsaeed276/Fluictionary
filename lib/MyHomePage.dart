import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "0e635476c3380d23a1c296bdd1bdfbe9dab9640d";

  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async { // for the empty
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }


    _streamController.add("waiting");
    Response response = await get(_url + _controller.text.trim(),
        headers: {"Authorization": "Token " + _token}).catchError((error)=> print(error));
    _streamController.add(json.decode(response.body));

  }

  Widget rightSide(AsyncSnapshot snapshot, int index) {
    if (snapshot.data["definitions"][index]["image_url"] != null) {
      return CircleAvatar(
        backgroundImage:
            NetworkImage(snapshot.data["definitions"][index]["image_url"]),
      );
    } else if (snapshot.data["definitions"][index]["emoji"] != null) {
      return CircleAvatar(
        backgroundImage:
            NetworkImage(snapshot.data["definitions"][index]["emoji"]),
      );
    } else
      return null;
  }

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardsize = 160;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Flictionary"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                      autocorrect: true,
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        _search();
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search for a word",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _search();
                },
              )
            ],
          ),
        ),
      ),




      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
        ),
        margin: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Enter a search word"),
              );
            }

            if (snapshot.data == "waiting") {
              return Center(
                child: CircularProgressIndicator(),
              );
            }


            return ListView.builder(
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                return ListBody(
                  children: <Widget>[
                    Container(
                      width: screenWidth,
                      height: cardsize,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(70),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth,
                            height: cardsize/2,
                            decoration: BoxDecoration(
                              color:  Colors.grey,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(70),
                              ),
                            ),
                            child: ListTile(
                              leading: rightSide(snapshot, index),
                              title: Text(_controller.text.trim() +
                                  "(" +
                                  snapshot.data["definitions"][index]["type"] +
                                  ")"),
                            ),
                          ),

                          Container(
                            width: screenWidth,
                            height: cardsize/2,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(70),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data["definitions"][index]["definition"]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

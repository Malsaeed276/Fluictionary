import 'package:fluictionary/pages/DictionaryPage/DictionaryBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class DictionaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return page();
  }
}

class page extends State<DictionaryPage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "0e635476c3380d23a1c296bdd1bdfbe9dab9640d";

  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async {
    // for the empty
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(_url + _controller.text.trim(),
            headers: {"Authorization": "Token " + _token})
        .catchError((error) => print(error));
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black87,
      body:
          //DictionaryBody(),
          Column(
        children: [
          Container(
            // for the back down color
            color: Colors.grey,
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),

            //for the back sign
            child: Container(
              padding: EdgeInsets.only(bottom: 0),
              width: screenWidth,
              height: screenHeight / 3,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        //top right area
                        alignment: Alignment.topLeft,

                        child: Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: Colors.black87,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30)),
                          ),
                          child: RawMaterialButton(
                            elevation: 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                              color: Colors.white,
                            ),
                            shape: CircleBorder(),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Align(
                        //top right area
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: Colors.black87,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30)),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Dictionary',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Icon(
                                  Icons.collections_bookmark,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //text field
                  Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 3,
                    child: Container(
                      width: screenWidth / 1.5,
                      margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: TextFormField(
                        autocorrect: true,
                        onChanged: (String text) {
                          if (_debounce?.isActive ?? false) _debounce.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 1000), () {
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
                ],
              ),
            ),
          ),


           Expanded(
             child: Container(
                decoration: BoxDecoration(
                  // for check the problem
                //  color: Colors.amber,
                ),
                //margin: const EdgeInsets.all(5.0),

                child: StreamBuilder(
                  stream: _stream,
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        padding: EdgeInsets.all(0),
                        width: screenWidth,
                        height: cardsize / 2,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(70),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Enter a search word",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    if (snapshot.data == "waiting") {
                      return Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          heightFactor: 2,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data["definitions"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListBody(
                            children: <Widget>[
                              Container(
                                color: Colors.grey,
                                child: Container(

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
                                        height: cardsize / 2,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(70),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: rightSide(snapshot, index),
                                          title: Text(_controller.text.trim() +
                                              "(" +
                                              snapshot.data["definitions"][index]
                                                  ["type"] +
                                              ")"),
                                        ),
                                      ),

                                      Container(
                                        width: screenWidth,
                                        height: cardsize / 2,
                                        margin: EdgeInsets.only(left: 5.0,right:5,),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(70),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot.data["definitions"]
                                              [index]["definition"]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                  },
                ),
              ),
           ),

        ],
      ),
    );
  }
}

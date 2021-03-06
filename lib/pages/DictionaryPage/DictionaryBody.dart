import 'package:flutter/material.dart';

class DictionaryBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return page();
  }
}

class page extends State<DictionaryBody> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardsize = 160;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: const EdgeInsets.all(5.0),
      child: StreamBuilder(
        //stream: _stream,
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
                           /* leading: rightSide(snapshot, index),
                            title: Text(_controller.text.trim() +
                                "(" +
                                snapshot.data["definitions"][index]["type"] +
                                ")"),*/
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
    );
  }
}

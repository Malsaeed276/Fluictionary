import 'package:fluictionary/pages/DictionaryPage/DictionaryBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return page();
  }
}

class page extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardsize = 160;


    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        child: Column(
          children: [

            Container(
              color: Colors.grey,
              child: Container(
                width: screenWidth,
                height: screenHeight / 3,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(70),
                  ),
                ),
                child: Row(
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
              ),
            ),

            DictionaryBody(),
          ],
        ),
      ),
    );
  }
}

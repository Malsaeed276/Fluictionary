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

          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class cards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: CardStack()

      ),
    );
  }
}

class CardStack extends StatefulWidget {
  const CardStack({
    Key key,
  }) : super(key: key);

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack>
    with SingleTickerProviderStateMixin {
  final List<MyCard> _cards = [
    MyCard(color: Colors.deepPurpleAccent, text: '1234'),
    MyCard(color: Colors.indigo, text: '2345'),
    MyCard(color: Colors.blue, text: '3456'),
    MyCard(color: Colors.greenAccent, text: '4567'),
    MyCard(color: Colors.yellow, text: '5678'),
    MyCard(color: Colors.orangeAccent, text: '6789'),
    MyCard(color: Colors.redAccent, text: '7890'),
  ];

  final Size _cardSize = Size(300.0, 180.0);
  MyCard _currCard;
  final double _cardOffset = 30.0;

  AnimationController _animationController;
  Animation<Offset> _selectedCardTransition;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateSelectedCard(int index) {
    final double dy = (index * _cardOffset) / _cardSize.height;
    final offset = Offset(0.0, -dy);
    _selectedCardTransition = Tween<Offset>(
      begin: Offset.zero,
      end: offset,
    ).animate(
      _curvedAnimation,
    );
  }

  Animation<Offset> _cardsPosition(int index) {
    final int currIndex = _cards.indexOf(_currCard);
    //translate the cards below currently selected card in order to fill up
    // the gutter space left out by the selected card
    final double dy =
    index > currIndex ? (_cardOffset) / _cardSize.height : 0.0;

    return Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, 1.5 - dy),
    ).animate(_curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
//    const _DarkColor1 = const Color(333333);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double backSize = (MediaQuery.of(context).size.width) / 5;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onTap: () {
          _currCard = null;
          _animationController.reverse();
        },
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Align(
                            // top left area
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
                                  size: 35,
                                  color: Colors.white,
                                ),
                                shape: CircleBorder(),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                        ],
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
                                  'Note Cards',
                                  style: TextStyle(fontSize: 25,color: Colors.white,),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Icon(
                                  Icons.card_membership,
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


                Positioned(

                  child: Padding(
                    padding: EdgeInsets.only(top: 160.0),
                    child: Stack(
                    children:
                    List.generate(_cards.length, (index) {
                      final MyCard card = _cards[index];

                      return SlideTransition(
                        position: _currCard == card
                            ? _selectedCardTransition
                            : _cardsPosition(index),
                        child: Transform.translate(
                          offset: Offset(0.0, index * _cardOffset),
                          child: GestureDetector(
                            onTap: () {
                              _setCurrCard(card);
                            },
                            child: Container(
                              width: _cardSize.width,
                              height: _cardSize.height,
                              decoration: BoxDecoration(
                                color: card.color,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '• • • • ${card.text}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                ),
                  ),
                )


              ],
            )
        ),
      ),
    );
  }

  void _setCurrCard(MyCard card) {
    if (_currCard == card) {
      _animationController.reverse();
      _currCard = null;
    } else {
      setState(() {
        _currCard = card;
      });
      _animateSelectedCard(_cards.indexOf(card));
      _animationController.forward();
    }
  }
}

class MyCard {
  final Color color;
  final String text;

  MyCard({@required this.color, @required this.text});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MyCard && o.color == color && o.text == text;
  }

  @override
  int get hashCode => color.hashCode ^ text.hashCode;

  @override
  String toString() => 'MyCard(color: $color, text: $text)';
}

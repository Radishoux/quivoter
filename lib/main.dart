import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'swipeable_card.dart'; // Make sure to import the SwipeableCard widget
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class CardInfo {
  final int id;
  final String category;
  final String team;
  final String ideaFR;
  final String ideaEN;
  CardInfo(
      {required this.id,
      required this.category,
      required this.team,
      required this.ideaFR,
      required this.ideaEN});

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      id: json['id'],
      category: json['category'],
      team: json['team'],
      ideaFR: json['ideaFR'],
      ideaEN: json['ideaEN'],
    );
  }

  @override
  String toString() {
    return 'CardInfo{id: $id, category: $category, team: $team, ideaFR: $ideaFR, ideaEN: $ideaEN}';
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CardInfo> mainStack = [];
  List<CardInfo> leftPile = [];
  List<CardInfo> rightPile = [];
  List<CardInfo> topPile = [];
  List<CardInfo> bottomPile = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final String response =
          await rootBundle.loadString('assets/card_list.json');
      final data = json.decode(response) as Map<String, dynamic>;
      if (data.containsKey('cards')) {
        final List<dynamic> cardsJson = data['cards'];
        cardsJson.shuffle(Random());
        setState(() {
          mainStack =
              cardsJson.map((cardJson) => CardInfo.fromJson(cardJson)).toList();
        });
      }
    } catch (e) {
      print('Error loading cards: $e');
    }
  }

  void _moveCardToLeftPile(int index) {
    setState(() {
      final cardInfo = mainStack[index];
      print(
          'Moving card to Left Pile: id: ${cardInfo.id}, category: ${cardInfo.category}, team: ${cardInfo.team}, ideaFR: ${cardInfo.ideaFR}, ideaEN: ${cardInfo.ideaEN}');
      leftPile.add(mainStack[index]);
      mainStack.removeAt(index);
    });
  }

  void _moveCardToRightPile(int index) {
    setState(() {
      print(
          'Moving card to Right Pile: ${mainStack[index]}'); // Log card info and direction
      rightPile.add(mainStack[index]);
      mainStack.removeAt(index);
    });
  }

  void _moveCardToBottomPile(int index) {
    setState(() {
      print(
          'Moving card to Bottom Pile: ${mainStack[index]}'); // Log card info and direction
      bottomPile.add(mainStack[index]);
      mainStack.removeAt(index);
    });
  }

  void _moveCardToTopPile(int index) {
    setState(() {
      print(
          'Moving card to Top Pile: ${mainStack[index]}'); // Log card info and direction
      topPile.add(mainStack[index]);
      mainStack.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: mainStack.isNotEmpty
              ? Stack(
                  alignment: Alignment.center,
                  children: mainStack.asMap().entries.map((entry) {
                    int idx = entry.key;
                    CardInfo cardInfo = entry.value;
                    return SwipeableCard(
                      key: ValueKey(cardInfo.ideaFR),
                      child: Container(
                        width: 300,
                        height: 500,
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            cardInfo.ideaFR,
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      onSwipeLeft: () => _moveCardToLeftPile(idx),
                      onSwipeRight: () => _moveCardToRightPile(idx),
                      onSwipeUp: () => _moveCardToTopPile(idx),
                      onSwipeDown: () => _moveCardToBottomPile(idx),
                    );
                  }).toList(),
                )
              : Text(
                  'Left Pile: ${leftPile.length}, Right Pile: ${rightPile.length}, Top Pile: ${topPile.length}, Bottom Pile: ${bottomPile.length}'),
        ),
      ),
    );
  }
}

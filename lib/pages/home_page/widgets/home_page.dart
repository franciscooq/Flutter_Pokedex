import 'package:flutter/material.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';

import 'app_bar_home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statusWidth = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: -(240 / 4.2),
            left: screenWidth - (240 / 1.6),
            child: Opacity(
              child: Image.asset(
                ConstsApp.blackPokeball,
                height: 240,
                width: 240,
              ),
              opacity: 0.1,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: statusWidth,
                ),
                AppBarHome(),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text('Pokemon 1'),
                        ),
                        ListTile(
                          title: Text('Pokemon 2'),
                        ),
                        ListTile(
                          title: Text('Pokemon 3'),
                        ),
                        ListTile(
                          title: Text('Pokemon 4'),
                        ),
                        ListTile(
                          title: Text('Pokemon 5'),
                        ),
                        ListTile(
                          title: Text('Pokemon 6'),
                        ),
                        ListTile(
                          title: Text('Pokemon 7'),
                        ),
                        ListTile(
                          title: Text('Pokemon 8'),
                        ),
                        ListTile(
                          title: Text('Pokemon 9'),
                        ),
                        ListTile(
                          title: Text('Pokemon 10'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:simple_animations/simple_animations.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  Pokemon _pokemon;
  PokeApiStore _pokeApiStore;
  MultiTrackTween _pokeAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.index);
    _pokeApiStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokeApiStore.pokemonCurrent;

    _pokeAnimation = MultiTrackTween([
      Track("rotationPokeball").add(
        Duration(seconds: 7),
        Tween(begin: 0.0, end: 6.0),
        curve: Curves.linear,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (BuildContext context) {
            return AppBar(
              elevation: 0,
              backgroundColor: _pokeApiStore.pokemonColor,
              title: Opacity(
                opacity: 0,
                child: Text(
                  _pokemon.name,
                  style: TextStyle(
                    fontFamily: 'Google',
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Observer(
            builder: (context) {
              return Container(
                color: _pokeApiStore.pokemonColor,
              );
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 0,
            cornerRadius: 30,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.7, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                _pokeApiStore.setPokemonCurrent(index: index);
              },
              itemCount: _pokeApiStore.pokeAPI.pokemon.length,
              itemBuilder: (BuildContext context, int inxBuilder) {
                Pokemon _pokeItem = _pokeApiStore.getPokemon(index: inxBuilder);
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ControlledAnimation(
                        playback: Playback.LOOP,
                        duration: _pokeAnimation.duration,
                        tween: _pokeAnimation,
                        builder: (context, animation) {
                          return Transform.rotate(
                            angle: animation['rotationPokeball'],
                            child: Opacity(
                              opacity: 0.2,
                              child: Image.asset(
                                ConstsApp.whitePokeball,
                                height: 300,
                                width: 300,
                              ),
                            ),
                          );
                        }),
                    Observer(builder: (context) {
                      return AnimatedPadding(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.bounceInOut,
                          padding: EdgeInsets.all(
                              inxBuilder == _pokeApiStore.currentPosition
                                  ? 0
                                  : 60),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 50,
                            ),
                            child: Hero(
                              tag: _pokeItem.name,
                              child: _pokeApiStore.getImage(
                                  number: _pokeItem.num, index: inxBuilder),
                            ),
                          ));
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

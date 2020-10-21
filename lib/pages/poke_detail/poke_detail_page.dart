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
  double _progress = 0;
  double _multiple = 0;
  double _opacity = 0;
  double _opacityTitleAppBar = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.index, viewportFraction: 0.5);
    _pokeApiStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokeApiStore.pokemonCurrent;

    _pokeAnimation = MultiTrackTween([
      Track("rotationPokeball").add(
        Duration(seconds: 7),
        Tween(begin: 0.0, end: 6.0),
        curve: Curves.linear,
      )
    ]);
    _progress = 0;
    _multiple = 1;
    _opacity = 1;
    _opacityTitleAppBar = 0;
  }

  double interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Observer(
            builder: (context) {
              return AnimatedContainer(
                child: Stack(
                  children: <Widget>[
                    AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      actions: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: Stack(
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
                                        opacity: _opacityTitleAppBar <= 0.2
                                            ? 0.2
                                            : 0,
                                        child: Image.asset(
                                          ConstsApp.whitePokeball,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    );
                                  }),
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width / 3.0,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        _pokeApiStore.pokemonCurrent.name,
                        style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.09,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 20, top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              setTiposDetalhe(
                                  _pokeApiStore.pokemonCurrent.type),
                              Text(
                                '#' +
                                    _pokeApiStore.pokemonCurrent.num.toString(),
                                style: TextStyle(
                                    fontFamily: 'Google',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height / 3,
                duration: Duration(milliseconds: 300),
                color: _pokeApiStore.pokemonColor,
              );
            },
          ),
          SlidingSheet(
            listener: (state) {
              setState(() {
                _progress = state.progress;
                _multiple = 1 - interval(0.0, 0.89, _progress);
                _opacity = _multiple;
                _opacityTitleAppBar =
                    _multiple = interval(0.55, 0.89, _progress);
              });
            },
            elevation: 0,
            cornerRadius: 30,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.7, 0.89],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
          Opacity(
            opacity: _opacity,
            child: Padding(
              child: SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _pokeApiStore.setPokemonCurrent(index: index);
                  },
                  itemCount: _pokeApiStore.pokeAPI.pokemon.length,
                  itemBuilder: (BuildContext context, int inxBuilder) {
                    Pokemon _pokeItem =
                        _pokeApiStore.getPokemon(index: inxBuilder);
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
                                    height: 200,
                                    width: 200,
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
              padding: EdgeInsets.only(
                  top: _opacityTitleAppBar == 1
                      ? 1000
                      : (MediaQuery.of(context).size.height * 0.12) -
                          _progress * 50),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------
  Widget setTiposDetalhe(List<String> types) {
    List<Widget> lista = [];
    types.forEach((nome) {
      lista.add(
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(80, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  nome.trim(),
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
      );
    });
    return Row(
      children: lista,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

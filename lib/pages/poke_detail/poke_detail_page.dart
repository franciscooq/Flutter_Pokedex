import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatelessWidget {
  final int index;

  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pokeApiStore = Provider.of<PokeApiStore>(context);
    Pokemon _pokemon = _pokeApiStore.pokemonCurrent;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (BuildContext context) {
            return AppBar(
              elevation: 0,
              backgroundColor: ConstsAPI.getColorType(
                  type: _pokeApiStore.pokemonCurrent.type[0]),
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
                color: ConstsAPI.getColorType(
                    type: _pokeApiStore.pokemonCurrent.type[0]),
              );
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 0,
            cornerRadius: 16,
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
          Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: SizedBox(
              height: 220,
              child: PageView.builder(
                onPageChanged: (inxChange) {
                  _pokeApiStore.setPokemonCurrent(index: (index + inxChange));
                },
                itemCount: _pokeApiStore.pokeAPI.pokemon.length,
                itemBuilder: (BuildContext context, int inxBuilder) {
                  return Observer(
                    builder: (context) {
                      return _pokeApiStore.getImage(
                          number: _pokeApiStore.pokemonCurrent.num);
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

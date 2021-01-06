import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/components/circluar_progress_about.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/models/specie.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:flutter_pokedex/stores/pokeapiv2_store.dart';
import 'package:get_it/get_it.dart';

class AbaEvolucao extends StatelessWidget {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
  final PokeApiStore _pokeApiStore = GetIt.instance<PokeApiStore>();

  Widget resizePokemon(Widget pokemonImage) {
    return SizedBox(height: 80, width: 80, child: pokemonImage);
  }

  List<Widget> getEvolucao(Pokemon pokemon) {
    List<Widget> _list = [];

    if (pokemon.prevEvolution != null) {
      pokemon.prevEvolution.forEach((element) {
        _list.add(resizePokemon(_pokeApiStore.getImage(number: element.num)));
        _list.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              element.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        _list.add(Icon(Icons.keyboard_arrow_down));
      });
    }

    _list.add(resizePokemon(_pokeApiStore.getImage(number: pokemon.num)));
    _list.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text(
          pokemon.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (pokemon.nextEvolution != null) {
      _list.add(Icon(Icons.keyboard_arrow_down));
      pokemon.nextEvolution.forEach((element) {
        _list.add(resizePokemon(_pokeApiStore.getImage(number: element.num)));
        _list.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              element.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        if (pokemon.nextEvolution.last.name != element.name) {
          _list.add(Icon(Icons.keyboard_arrow_down));
        }
      });
    }

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: Observer(builder: (context) {
          Pokemon pokemon = _pokeApiStore.pokemonCurrent;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getEvolucao(pokemon),
            ),
          );
        }),
      ),
    );
  }
}

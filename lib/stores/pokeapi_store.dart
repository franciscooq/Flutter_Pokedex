import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/consts/consts_api.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  PokeAPI _pokeAPI;

  @computed
  PokeAPI get pokeAPI => _pokeAPI;

  @action
  fetchPokemonList() {
    _pokeAPI = null;
    loadPokeAPI().then((pokeList) {
      _pokeAPI = pokeList;
    });
  }

  @action
  getPokemon({int index}) {
    return _pokeAPI.pokemon[index];
  }

  @action
  Widget getImage({String number}) {
    return CachedNetworkImage(
      placeholder: (context, url) => new Container(
        color: Colors.transparent,
      ),
      imageUrl:
          'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$number.png',
    );
  }

  @action
  setPokemonAtual({int index}){
    return _pokeAPI.pokemon[index];
  }

  @action
  getPokeonAtual({int index}){
    return _pokeAPI.pokemon[index];
  }

  Future<PokeAPI> loadPokeAPI() async {
    try {
      final response = await http.get(ConstsAPI.pokeApiURL);
      var decodeJson = jsonDecode(response.body);
      return PokeAPI.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Erro ao carregar lista" + stacktrace.toString());
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_pokedex/pages/home_page/widgets/home_page.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:flutter_pokedex/stores/pokeapiv2_store.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt getItPokeApiStore = GetIt.instance;
  getItPokeApiStore.registerSingleton<PokeApiStore>(PokeApiStore());
  getItPokeApiStore.registerSingleton<PokeApiV2Store>(PokeApiV2Store());

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pokedex - Pokemon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

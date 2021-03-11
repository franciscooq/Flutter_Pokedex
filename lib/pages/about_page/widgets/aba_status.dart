import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/models/pokeapiv2.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:flutter_pokedex/stores/pokeapiv2_store.dart';
import 'package:get_it/get_it.dart';

class AbaStatus extends StatelessWidget {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
  final PokeApiStore _pokeApiStore = GetIt.instance<PokeApiStore>();

  List<int> getStatusPokemon(PokeApiV2 pokeApiV2) {
    List<int> lista = [1, 2, 3, 4, 5, 6, 7];
    int sum = 0;

    pokeApiV2.stats.forEach((element) {
      sum = sum + element.baseStat;
      switch (element.stat.name) {
        case 'speed':
          lista[0] = element.baseStat;
          break;
        case 'special-defense':
          lista[1] = element.baseStat;
          break;
        case 'special-attack':
          lista[2] = element.baseStat;
          break;
        case 'defense':
          lista[3] = element.baseStat;
          break;
        case 'attack':
          lista[4] = element.baseStat;
          break;
        case 'hp':
          lista[5] = element.baseStat;
          break;
      }
    });
    lista[6] = sum;
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: Observer(builder: (context) {
          return Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Velocidade',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sp. Def.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sp. At.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Defesa',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ataque',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Hp',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Observer(builder: (context) {
                List<int> _lista = getStatusPokemon(_pokeApiV2Store.pokeApiV2);
                return Column(
                  children: <Widget>[
                    Text(
                      _lista[0].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _lista[1].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _lista[2].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _lista[3].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _lista[4].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _lista[5].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _lista[6].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              }),
              SizedBox(width: 10),
              Expanded(
                child: Observer(builder: (context) {
                  List<int> _lista =
                      getStatusPokemon(_pokeApiV2Store.pokeApiV2);
                  double widthF =
                      _lista[6] > 600 ? _lista[6] / _lista[6] : _lista[6] / 600;
                  return Column(
                    children: <Widget>[
                      StatusBar(
                        widthFactor: _lista[0] / 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusBar(
                        widthFactor: _lista[1] / 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusBar(
                        widthFactor: _lista[2] / 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusBar(
                        widthFactor: _lista[3] / 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusBar(
                        widthFactor: _lista[4] / 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusBar(
                        widthFactor: _lista[5] / 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StatusBar(
                        widthFactor: widthF,
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  final double widthFactor;

  const StatusBar({Key key, this.widthFactor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 17,
      child: Center(
        child: Container(
          height: 4,
          width: MediaQuery.of(context).size.width * .4,
          alignment: Alignment.centerLeft,
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: Colors.grey,
          ),
          child: FractionallySizedBox(
            widthFactor: widthFactor >= 600 ? 550 : widthFactor,
            heightFactor: 1.0,
            child: Container(
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: widthFactor > 0.5 ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:peliculas2/src/providers/peliculas_provider.dart';
import '../models/pelicula_model.dart';

class DataSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar película';

  String seleccion = '';
  final peliculasProvider = PeliculasProvider();
  // final pelicula = Pelicula();

  final peliculas = [
    'Spiderman',
    'Hulk',
    'Batman',
    'Superman',
    'Flash',
    'Joker',
    'Avatar 2',
    'Gato con botas 2',
  ];

  final peliculasRecientes = ['Avatar 2', 'Gato con botas 2'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        //funciona perfectamente sin definir el close
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  //  if (query != null && peliculas.contains(query.toLowerCase())) {
  //   return ListTile(
  //     title: Text(query),
  //     onTap: () {

  //     }
  //   );
  //  } else if (query == "") {
  //   return const Text("");
  //  } else {
  //   return ListTile(
  //     title: const Text("No results found"),
  //     onTap: () {

  //     }
  //   );
  //  }
  //  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
              children: peliculas!.map((pelicula) {
            return ListTile(
              leading: FadeInImage(
                image: NetworkImage(pelicula.getPosterImage().toString()),
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                width: 50.0,
                fit: BoxFit.contain,
              ),
              title: Text(pelicula.title.toString()),
              subtitle: Text(pelicula.originalTitle.toString()),
              onTap: () {
                close(context, null);
                pelicula.uniqueID = '';
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

    // final listaSugerida = (query.isEmpty)
    //                     ? peliculasRecientes
    //                     : peliculas.where(
    //                       (element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       leading: const Icon(Icons.movie),
    //       title: Text(listaSugerida[index]),
    //       onTap: () {
    //         seleccion = listaSugerida[index];
    //         showResults(context);
    //       },
    //     );
    //   },
    // );
  }
}

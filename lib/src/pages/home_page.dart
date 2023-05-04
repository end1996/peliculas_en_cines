import 'package:flutter/material.dart';
import 'package:peliculas2/src/models/pelicula_model.dart';
import 'package:peliculas2/src/providers/peliculas_provider.dart';
import 'package:peliculas2/src/search/search_delegate.dart';
import 'package:peliculas2/src/widgets/card_swiper_widget.dart';
import 'package:peliculas2/src/widgets/movie_horizontal_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final peliculasProvider = PeliculasProvider();
  
  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelicula en cines'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch()
                );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _crearSwiper(),
          _footer(context),
        ],
      ),
    );
  }

  Widget _crearSwiper() {
    return FutureBuilder<List<Pelicula>>(
        future: peliculasProvider.getEnCines(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(peliculas: snapshot.data!);
          } else {
            return const Center(
                child: CircularProgressIndicator());
          }
        });
  }

  Widget _footer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          //Anteriormente era un future pero para agregar un infinite scroll en las peliculas populares fue necesario usar un Stream
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            // initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {

             if(snapshot.hasData) {
              return MovieHorizontal(peliculas: snapshot.data!, siguientePagina: peliculasProvider.getPopulares);
             } else {
              return const Center(child: CircularProgressIndicator());
             }
              

            },
          ),
        ],
      ),
    );
  }
}

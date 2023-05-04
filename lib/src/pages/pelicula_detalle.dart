import 'package:flutter/material.dart';

import 'package:peliculas2/src/providers/peliculas_provider.dart';
import '../models/actores_model.dart';
import '../models/pelicula_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PeliculaDetallePage extends StatelessWidget {
  const PeliculaDetallePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pelicula = ModalRoute.of(context)?.settings.arguments as Pelicula;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          crearSliverAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10.0),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              const SizedBox(
                height: 15.0,
              ),
              _crearCasting(pelicula),
            ]),
          ),
        ],
      ),
    );
  }

  Widget crearSliverAppbar(Pelicula pelicula) {
    return SliverAppBar(
      centerTitle: true,
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          pelicula.title.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackdropPathImage().toString()),
          placeholder: const AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: pelicula.uniqueID.toString(),
            // child: ClipRRect(
            //   borderRadius: BorderRadius.circular(20.0),
            //   child: CachedNetworkImage(
            //         imageUrl: pelicula.getPosterImage(),
            //         placeholder: (context, url) => CircularProgressIndicator(),
            //         errorWidget: (context, url, error) => Icon(Icons.error),
            //         height: 150.0,

            //         ),
            // ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImage().toString()),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pelicula.title.toString(),
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                pelicula.originalTitle.toString(),
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(Icons.star_border, color: Colors.amber),
                  Text(pelicula.voteAverage.toString(),
                      style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            pelicula.overview.toString(),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return crearActoresPageView(snapshot.data);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
          itemCount: actores.length,
          pageSnapping: false,
          controller: PageController(viewportFraction: 0.3, initialPage: 1),
          itemBuilder: (context, index) {
            return _actorTarjeta(actores[index]);
          }),
    );
  }
}

Widget _actorTarjeta(Actor actor) {
  return SizedBox(
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: const AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(actor.getFoto().toString()),
            fit: BoxFit.cover,
            height: 150.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          actor.name.toString(),
          overflow: TextOverflow.ellipsis,
        )
      ],
    ),
  );
}

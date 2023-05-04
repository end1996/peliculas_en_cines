import 'package:flutter/material.dart';

import '../models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  MovieHorizontal({required this.peliculas,super.key, required this.siguientePagina});

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  final pageController = PageController(
    viewportFraction: 0.3,
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    pageController.addListener(() {
      //Se coloca menos -200 para que cargue un poco antes de terminar la primera lista de peliculas
      if(pageController.position.pixels >= pageController.position.maxScrollExtent - 200){
        siguientePagina();
      }
     });

    return SizedBox(
        height: screenSize.height * 0.3,
        //Se cambió a builder para optimizar el app
        child: PageView.builder(
            pageSnapping: false,
            controller: pageController,
            // children: _tarjetas(context)
            itemCount: peliculas.length,
            itemBuilder: (context, index) => _tarjeta(context, peliculas[index]),
            ));
  }

  Widget _tarjeta (BuildContext context, Pelicula pelicula) {

    pelicula.uniqueID = "${pelicula.id}-movieHorizontal";
    
    final tarjeta = Container(
          margin: const EdgeInsets.only(right: 15.0),
          child: Column(
            children: [
              Hero(
                tag: pelicula.uniqueID.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(pelicula.getPosterImage()),
                    fit: BoxFit.cover,
                    height: 160.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                pelicula.title.toString(),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        );
        return GestureDetector(
          child: tarjeta,
          onTap: () {
            Navigator.pushNamed(context, 'detalle',arguments: pelicula);
          },
        );
  }
  
  // List<Widget> _tarjetas(BuildContext context) {
  //   return peliculas.map(
  //     (pelicula) {
  //       return Container(
  //         margin: const EdgeInsets.only(right: 15.0),
  //         child: Column(
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(20.0),
  //               child: FadeInImage(
  //                 placeholder: const AssetImage('assets/img/no-image.jpg'),
  //                 image: NetworkImage(pelicula.getPosterImage()),
  //                 fit: BoxFit.cover,
  //                 height: 160.0,
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 5.0,
  //             ),
  //             Text(
  //               pelicula.title.toString(),
  //               overflow: TextOverflow.ellipsis,
  //               style: Theme.of(context).textTheme.bodySmall,
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   ).toList();
  // }
}

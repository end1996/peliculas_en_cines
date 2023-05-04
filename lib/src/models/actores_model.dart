class Cast {

  List<Actor> actores = [];

  Cast.fromJsonList( List<dynamic> jsonList  ){

    // ignore: unnecessary_null_comparison
    if ( jsonList == null ) return;

    for (var element in jsonList) {
      final actor = Actor.fromJsonMap(element);
      actores.add(actor);
    }
  }

}

class Actor {
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;
  int? castId;
  String? character;
  String? creditId;
  int? order;
  String? department;
  String? job;

  Actor({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.originalName,
    this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    this.department,
    this.job,
  });

 Actor.fromJsonMap(Map <String,dynamic> jsonList){
adult =  jsonList['adult'];
gender = jsonList['gender'];
id = jsonList['id'];
knownForDepartment = jsonList['known_for_department'];
name = jsonList['name'];
originalName = jsonList['original_name'];
popularity = jsonList['popularity'];
profilePath = jsonList['profile_path'];
castId = jsonList['cast_id'];
character = jsonList['character'];
creditId = jsonList['credit_id'];
order = jsonList['order'];
department = jsonList['department'];
job = jsonList['job'];
 }

getFoto() {
    if (profilePath == null) {
      return 'https://www.intra-tp.com/wp-content/uploads/2017/02/no-avatar.png';
    } else {
      return "https://image.tmdb.org/t/p/w500/$profilePath";
    }
  }
} 



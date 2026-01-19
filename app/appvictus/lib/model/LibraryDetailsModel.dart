import 'package:appvictus/model/LibraryModel.dart';
import 'package:appvictus/model/LibrarySectionModel.dart';

class LibraryDetailsModel extends LibraryModel{

  int idStar = -1, idLike = -1, idDone = -1, idLibraryUser = -1, currentIndexPlayer = -1;

  List<LibrarySectionModel> sections = [];


  LibraryDetailsModel(super.id, super.url, super.title, super.desc, super.percent, bool star, int idStar, bool like, int idLike, bool done, int idDone, List<LibrarySectionModel> sec, int idLibraryUser, int currentIndexPlayer){
    this.sections = sec;
    this.idDone = idDone;
    this.idLike = idLike;
    this.idStar = idStar;
    this.idLibraryUser = idLibraryUser;
    this.currentIndexPlayer = currentIndexPlayer;
  }


  factory LibraryDetailsModel.FromJson(int id, String url, String title, String desc, int percent,Map<String, dynamic> json){

    List<LibrarySectionModel> sections = [];

    for(var item in json["sections"]){
      sections.add(LibrarySectionModel.FromJson(item));
    }

    return LibraryDetailsModel(
        id,
        url,
        title,
        desc,
        percent,
        json["star"] ?? false,
        json["idRowStar"] ?? -1,
        json["gosto"] ?? false,
        json["idRowGosto"] ?? -1,
        json["done"] ?? false,
      json["idRowDone"] ?? -1,
      sections,
      json["idLibraryUser"] ?? -1,
      json["currentIndexPlayer"] ?? -1,
    );
  }

}
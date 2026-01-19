import 'package:appvictus/model/LibrarySectionContentModel.dart';

class LibrarySectionModel {
  int idSection = -1;
  String title = "";
  List<LibrarySectionContentModel> contents = [];

  LibrarySectionModel(this.idSection,this.title,this.contents);


  factory LibrarySectionModel.FromJson(Map<String, dynamic> json){

    List<LibrarySectionContentModel> content = [];
    for(var item in json["content"]){
      content.add(LibrarySectionContentModel.FromJson(item));
    }
    return LibrarySectionModel(
        json["idSection"] ?? 0,
        json["title"] ?? "",
      content
    );
  }
}
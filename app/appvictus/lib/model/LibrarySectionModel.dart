import 'package:appvictus/model/LibrarySectionContentModel.dart';

class LibrarySectionModel {
  String title = "";
  List<LibrarySectionContentModel> contents = [];

  LibrarySectionModel(this.title, this.contents);


  factory LibrarySectionModel.FromJson(Map<String, dynamic> json){

    List<LibrarySectionContentModel> content = [];
    for(var item in json["content"]){
      content.add(LibrarySectionContentModel.FromJson(item));
    }
    return LibrarySectionModel(
      json["title"] ?? "",
      content
    );
  }
}
class LibraryModel{
  String url = "", title = "", desc = "";
  int id =0 ,percent = 0;

  LibraryModel(this.id, this.url, this.title, this.desc, this.percent);

  factory LibraryModel.FromJson(Map<String, dynamic> json){
    return LibraryModel(
      json["id"] ?? 0,
      json["url"] ?? "",
      json["title"] ?? "",
      json["description"] ?? "",
      json["progress"] ?? 0
    );
  }
}
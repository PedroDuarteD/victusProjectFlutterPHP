class LibrarySectionContentModel{
  String title = "";

  LibrarySectionContentModel(this.title);

  factory LibrarySectionContentModel.FromJson(Map<String, dynamic> json){
    return LibrarySectionContentModel(
      json["title"] ?? ""
    );
  }
}
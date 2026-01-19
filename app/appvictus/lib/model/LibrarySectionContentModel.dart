class LibrarySectionContentModel{
  int idLibrarySectionContent = -1, idLibrarySection = -1;
  String title = "";
  String videoURL ="";

  LibrarySectionContentModel(this.idLibrarySectionContent,this.idLibrarySection,this.title, this.videoURL);

  factory LibrarySectionContentModel.FromJson(Map<String, dynamic> json){
    return LibrarySectionContentModel(
      json["id"] ?? -1,
      json["lib"] ?? -1,
      json["title"] ?? "",
      json["video"] ?? "",
    );
  }
}
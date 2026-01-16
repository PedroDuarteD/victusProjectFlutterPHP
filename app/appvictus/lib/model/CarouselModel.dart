class  CarouselModel{
  String title = "",description = "", actionTitle= "", url = "";

  CarouselModel(this.title, this.description, this.actionTitle, this.url);


  factory CarouselModel.FromJson(Map<String, dynamic> json){
    return CarouselModel(
      json["title"] ?? "",
      json["description"] ?? "",
      json["actionTitle"] ?? "",
      json["image"] ?? "",
    );
  }
}
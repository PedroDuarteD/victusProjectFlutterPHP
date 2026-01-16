class EventModel{
  String title = "",inicio = "";

  EventModel(this.title, this.inicio);

  factory EventModel.FromJson(Map<String, dynamic> json){
    return EventModel(
      json["title"] ?? "",
      json["inicio"] ?? ""
    );
  }
}
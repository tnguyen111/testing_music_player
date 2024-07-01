class Todo {
  int id;
  String itemName;
  String dateCreated;

  Todo(
      {required this.id,
        required this.itemName,
        required this.dateCreated});
//to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = <String, dynamic>{};
    map["item_name"] = itemName;
    map["date_created"] = dateCreated;
    return map;
  }
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map["id"] = id;
    map["item_name"] = itemName;
    map["date_created"] = dateCreated;
    return map;
  }
  //to be used when converting the row into object
  factory Todo.fromMap(Map<String, dynamic> data) =>   Todo(
      id: data['id'],
      itemName: data['item_name'],
      dateCreated: data['date_created']);
}
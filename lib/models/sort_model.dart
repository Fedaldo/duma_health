class SortByAppoint{
  int id;
  String text;

  SortByAppoint(this.id, this.text);

  static List<SortByAppoint> lists = [
    SortByAppoint(1, "In date"),
    SortByAppoint(2, "Distant date"),
    SortByAppoint(3, "Doctor"),
  ];
}
class SortByOrder{
  int id;
  String text;

  SortByOrder(this.id, this.text);

  static List<SortByOrder> lists = [
    SortByOrder(1, "In date"),
    SortByOrder(2, "Out date"),
    SortByOrder(3, "Status"),
    SortByOrder(4, "Amount"),
  ];
}
library notes;

class Note {

  final int id;
  final String title;
  final String date;
  final String desc;

  Note({required this.id , required this.title , required this.desc , required this.date});

  factory Note.fromJson(Map<String, dynamic> json)  {
    return Note(
      id :  int.parse(json['_id'].toString()),
      title: json['title'].toString(),
      date : json['date'].toString(),
      desc : json['desc'].toString()
    );
  }
}
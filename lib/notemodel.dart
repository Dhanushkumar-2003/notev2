class NoteModel {
  final int id;
  final String title;
  final String detail;

  NoteModel({
    required this.id,
    required this.title,
    required this.detail,
  });
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      detail: map['detail'],
    );
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'detail': detail,
      };
}

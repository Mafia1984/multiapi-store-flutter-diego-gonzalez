
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({required this.userId, required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: (json['title'] ?? '').toString(),
        body: (json['body'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}

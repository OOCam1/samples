import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.name, this.avatarImageUrl});
  final String? name;
  final String? avatarImageUrl;
  final String? id;

  factory User.fromJson(Map<String, dynamic> json) {
    final name = json['display_name'] as String?;
    final String? avatarImageUrl =
    (json['images'].length != 0 ? json['images'][0]['url'] : null) as String?;
    final id = json['id'] as String?;
    return User(name: name, avatarImageUrl: avatarImageUrl, id: id);
  }

  Map<String, dynamic> toJson() => {
        'display_name': name,
        'images': [
          {'url': avatarImageUrl}
        ],
        'id': id
      };

  @override
  List<Object?> get props => [name, avatarImageUrl, id];
}

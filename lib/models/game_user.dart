import 'dart:convert';

class GameUser {
  GameUser({
    this.name,
    this.email,
    this.password,
    this.imageUrl,
    this.points = 700,
    this.offlineLevel = 0,
  });

  String? name;
  String? email;
  String? password;
  String? imageUrl;
  int points;
  int offlineLevel;

  int get division {
    if (points < 1200) return 3;
    if (points < 2000) return 2;
    return 1;
  }

  String get profilePicture =>
      imageUrl ??
      'https://img.freepik.com/free-vector/cute-astronaut-working-with-computer-cartoon-vector-icon-illustration-science-technology-icon-concept-isolated-premium-vector-flat-cartoon-style_138676-4172.jpg';

  bool get isEmailSignin => password != null;

  bool get isGoogleSignin => password == null && email != null;

  bool get isGuest => email == null;

  bool get isAuth => name != null;

  String? get username => email?.split('@')[0];

  void addPoints(int addedPoints) {
    points += addedPoints;
  }

  void nextLevel() {
    if (offlineLevel == 100) return;
    offlineLevel++;
  }

  void clearUser() {
    name = null;
    email = null;
    imageUrl = null;
  }

  GameUser copyWith({
    String? name,
    String? email,
    String? password,
    String? imageUrl,
    int? points,
    int? offlineLevel,
  }) {
    return GameUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      imageUrl: imageUrl ?? this.imageUrl,
      points: points ?? this.points,
      offlineLevel: offlineLevel ?? this.offlineLevel,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (password != null) {
      result.addAll({'password': password});
    }
    if (imageUrl != null) {
      result.addAll({'imageUrl': imageUrl});
    }
    result.addAll({'points': points});
    result.addAll({'offlineLevel': offlineLevel});

    return result;
  }

  factory GameUser.fromMap(Map<String, dynamic> map) {
    return GameUser(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      imageUrl: map['imageUrl'],
      points: map['points']?.toInt() ?? 0,
      offlineLevel: map['offlineLevel']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameUser.fromJson(String source) =>
      GameUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GameUser(name: $name, email: $email, password: $password, imageUrl: $imageUrl, points: $points, offlineLevel: $offlineLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameUser &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.imageUrl == imageUrl &&
        other.points == points &&
        other.offlineLevel == offlineLevel;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        imageUrl.hashCode ^
        points.hashCode ^
        offlineLevel.hashCode;
  }
}

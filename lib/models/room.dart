import 'dart:convert';


class Room {
  String? user1;
  String? user2;
  String? roomName;
  
  Room({
    this.user1,
    this.user2,
    this.roomName,
  });


  Room copyWith({
    String? user1,
    String? user2,
    String? roomName,
  }) {
    return Room(
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      roomName: roomName ?? this.roomName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(user1 != null){
      result.addAll({'user1': user1});
    }
    if(user2 != null){
      result.addAll({'user2': user2});
    }
    if(roomName != null){
      result.addAll({'roomName': roomName});
    }
  
    return result;
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      user1: map['user1'],
      user2: map['user2'],
      roomName: map['roomName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  @override
  String toString() => 'Room(user1: $user1, user2: $user2, roomName: $roomName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Room &&
      other.user1 == user1 &&
      other.user2 == user2 &&
      other.roomName == roomName;
  }

  @override
  int get hashCode => user1.hashCode ^ user2.hashCode ^ roomName.hashCode;
}

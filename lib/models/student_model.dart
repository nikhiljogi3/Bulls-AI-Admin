class Student {
  final String id;
  final String name;
  final String email;
  final String batch;
  final String status; // Active, Inactive, Pending
  final DateTime joinedDate;
  final String? phoneNumber;
  final String? avatar;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.batch,
    required this.status,
    required this.joinedDate,
    this.phoneNumber,
    this.avatar,
  });

  factory Student.fromFirestore(Map<String, dynamic> data, String id) {
    return Student(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      batch: data['batch'] ?? '',
      status: data['status'] ?? 'Pending',
      joinedDate: data['joinedDate'] != null
          ? DateTime.parse(data['joinedDate'])
          : DateTime.now(),
      phoneNumber: data['phoneNumber'],
      avatar: data['avatar'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'batch': batch,
      'status': status,
      'joinedDate': joinedDate.toIso8601String(),
      'phoneNumber': phoneNumber,
      'avatar': avatar,
    };
  }
}

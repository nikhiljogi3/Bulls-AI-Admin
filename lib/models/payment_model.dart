class Payment {
  final String id;
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseName;
  final String amount;
  final String status; // Completed, Pending, Failed
  final DateTime paymentDate;
  final String paymentMethod; // Card, UPI, Net Banking
  final String? transactionId;

  Payment({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseName,
    required this.amount,
    required this.status,
    required this.paymentDate,
    required this.paymentMethod,
    this.transactionId,
  });

  factory Payment.fromFirestore(Map<String, dynamic> data, String id) {
    return Payment(
      id: id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      courseId: data['courseId'] ?? '',
      courseName: data['courseName'] ?? '',
      amount: data['amount'] ?? '',
      status: data['status'] ?? 'Pending',
      paymentDate: data['paymentDate'] != null
          ? DateTime.parse(data['paymentDate'])
          : DateTime.now(),
      paymentMethod: data['paymentMethod'] ?? 'Card',
      transactionId: data['transactionId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'courseId': courseId,
      'courseName': courseName,
      'amount': amount,
      'status': status,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
    };
  }
}

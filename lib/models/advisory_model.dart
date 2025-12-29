class AdvisoryTip {
  final String id;
  final String companyName;
  final String? logoUrl;
  final String term; // short | medium | long
  final DateTime publishedAt;
  final DateTime? expiresAt;
  final double targetPrice;
  final double expectedReturnPercent;
  final double buyMin;
  final double buyMax;
  final int horizonMinMonths;
  final int horizonMaxMonths;
  final String rationale; // why this trade
  final String action; // BUY | SELL | HOLD
  final bool isActive;

  AdvisoryTip({
    required this.id,
    required this.companyName,
    this.logoUrl,
    required this.term,
    required this.publishedAt,
    this.expiresAt,
    required this.targetPrice,
    required this.expectedReturnPercent,
    required this.buyMin,
    required this.buyMax,
    required this.horizonMinMonths,
    required this.horizonMaxMonths,
    required this.rationale,
    required this.action,
    required this.isActive,
  });

  factory AdvisoryTip.fromMap(Map<String, dynamic> data, String id) {
    return AdvisoryTip(
      id: id,
      companyName: data['companyName'] ?? '',
      logoUrl: data['logoUrl'],
      term: data['term'] ?? 'medium',
      publishedAt: _parseDate(data['publishedAt']) ?? DateTime.now(),
      expiresAt: _parseDate(data['expiresAt']),
      targetPrice: _toDouble(data['targetPrice']),
      expectedReturnPercent: _toDouble(data['expectedReturnPercent']),
      buyMin: _toDouble(data['buyMin']),
      buyMax: _toDouble(data['buyMax']),
      horizonMinMonths: (data['horizonMinMonths'] ?? 0) as int,
      horizonMaxMonths: (data['horizonMaxMonths'] ?? 0) as int,
      rationale: data['rationale'] ?? '',
      action: data['action'] ?? 'BUY',
      isActive: (data['isActive'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'logoUrl': logoUrl,
      'term': term,
      'publishedAt': publishedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'targetPrice': targetPrice,
      'expectedReturnPercent': expectedReturnPercent,
      'buyMin': buyMin,
      'buyMax': buyMax,
      'horizonMinMonths': horizonMinMonths,
      'horizonMaxMonths': horizonMaxMonths,
      'rationale': rationale,
      'action': action,
      'isActive': isActive,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toUtc();
    if (value is String) return DateTime.tryParse(value)?.toUtc();
    // Firestore Timestamp support without importing cloud_firestore
    final seconds = value is Map<String, dynamic> ? value['seconds'] : null;
    final nanoseconds = value is Map<String, dynamic>
        ? value['nanoseconds']
        : null;
    if (seconds is int) {
      return DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + ((nanoseconds is int ? nanoseconds : 0) ~/ 1000000),
        isUtc: true,
      );
    }
    return null;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  AdvisoryTip copyWith({
    String? id,
    String? companyName,
    String? logoUrl,
    String? term,
    DateTime? publishedAt,
    DateTime? expiresAt,
    double? targetPrice,
    double? expectedReturnPercent,
    double? buyMin,
    double? buyMax,
    int? horizonMinMonths,
    int? horizonMaxMonths,
    String? rationale,
    String? action,
    bool? isActive,
  }) {
    return AdvisoryTip(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      logoUrl: logoUrl ?? this.logoUrl,
      term: term ?? this.term,
      publishedAt: publishedAt ?? this.publishedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      targetPrice: targetPrice ?? this.targetPrice,
      expectedReturnPercent:
          expectedReturnPercent ?? this.expectedReturnPercent,
      buyMin: buyMin ?? this.buyMin,
      buyMax: buyMax ?? this.buyMax,
      horizonMinMonths: horizonMinMonths ?? this.horizonMinMonths,
      horizonMaxMonths: horizonMaxMonths ?? this.horizonMaxMonths,
      rationale: rationale ?? this.rationale,
      action: action ?? this.action,
      isActive: isActive ?? this.isActive,
    );
  }
}

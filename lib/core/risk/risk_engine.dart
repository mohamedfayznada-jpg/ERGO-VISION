enum RiskLevel { normal, caution, elevated, high, unavailable }

class RiskIndicator {
  final String region;
  final RiskLevel level;
  final double? value;
  final String reason;

  const RiskIndicator({
    required this.region,
    required this.level,
    required this.value,
    required this.reason,
  });
}

class RiskEngine {
  RiskIndicator trunk(double? angle) {
    if (angle == null) {
      return const RiskIndicator(
        region: 'trunk',
        level: RiskLevel.unavailable,
        value: null,
        reason: 'Insufficient landmark confidence.',
      );
    }
    if (angle <= 10) return RiskIndicator(region: 'trunk', level: RiskLevel.normal, value: angle, reason: 'Low trunk flexion indicator.');
    if (angle <= 20) return RiskIndicator(region: 'trunk', level: RiskLevel.caution, value: angle, reason: 'Moderate trunk flexion indicator.');
    if (angle <= 40) return RiskIndicator(region: 'trunk', level: RiskLevel.elevated, value: angle, reason: 'Elevated trunk flexion indicator.');
    return RiskIndicator(region: 'trunk', level: RiskLevel.high, value: angle, reason: 'High trunk flexion indicator.');
  }
}

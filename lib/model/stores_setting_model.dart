class StoreSettingsModel {
  final bool isOpen;
  final int deliveryFee;
  final int minOrderAmount;
  final int estimatedDeliveryMinutes;

  const StoreSettingsModel({
    this.isOpen = true,
    this.deliveryFee = 0,
    this.minOrderAmount = 0,
    this.estimatedDeliveryMinutes = 30,
  });

  factory StoreSettingsModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const StoreSettingsModel();
    return StoreSettingsModel(
      isOpen: map['isOpen'] ?? true,
      deliveryFee: (map['deliveryFee'] as num?)?.toInt() ?? 0,
      minOrderAmount: (map['minOrderAmount'] as num?)?.toInt() ?? 0,
      estimatedDeliveryMinutes:
          (map['estimatedDeliveryMinutes'] as num?)?.toInt() ?? 30,
    );
  }

  Map<String, dynamic> toMap() => {
        'isOpen': isOpen,
        'deliveryFee': deliveryFee,
        'minOrderAmount': minOrderAmount,
        'estimatedDeliveryMinutes': estimatedDeliveryMinutes,
      };

  StoreSettingsModel copyWith({
    bool? isOpen,
    int? deliveryFee,
    int? minOrderAmount,
    int? estimatedDeliveryMinutes,
  }) {
    return StoreSettingsModel(
      isOpen: isOpen ?? this.isOpen,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      estimatedDeliveryMinutes:
          estimatedDeliveryMinutes ?? this.estimatedDeliveryMinutes,
    );
  }
}
class StampBackgroundModel{
  final int id;
  final String label;
  final String assetLink;

  StampBackgroundModel({required this.id, required this.label, required this.assetLink});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final StampBackgroundModel otherTravelMode = other as StampBackgroundModel;
    return label == otherTravelMode.label && assetLink == otherTravelMode.assetLink;
  }

  @override
  int get hashCode => label.hashCode ^ assetLink.hashCode;
}
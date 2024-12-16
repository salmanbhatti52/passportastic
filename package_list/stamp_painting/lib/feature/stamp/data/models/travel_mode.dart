class TravelMode{
  final String label;
  final String assetLink;

  TravelMode({required this.label, required this.assetLink});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final TravelMode otherTravelMode = other as TravelMode;
    return label == otherTravelMode.label && assetLink == otherTravelMode.assetLink;
  }

  @override
  int get hashCode => label.hashCode ^ assetLink.hashCode;
}
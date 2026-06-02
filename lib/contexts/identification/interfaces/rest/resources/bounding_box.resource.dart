class BoundingBoxResource {
  final int x;
  final int y;
  final int w;
  final int h;

  const BoundingBoxResource({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory BoundingBoxResource.fromJson(Map<String, dynamic> json) {
    return BoundingBoxResource(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      w: (json['w'] as num).toInt(),
      h: (json['h'] as num).toInt(),
    );
  }
}


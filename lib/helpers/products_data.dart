class Properties {
  final int id;
  final String agentId;
  final String propertyType;
  final String propertyFor; // 'For Sale' or 'To Rent'
  final double price;
  final String status;
  final String address1;
  final String? location;
  final String? postcode;
  final String currency; // Defaulted to "NGN"
  final double? pricePerPcm;
  final double? pricePerPa;
  final String? availableFrom;
  final bool isTrending;
  final int bedroom;
  final int bathroom;
  final String description;
  final String? advanceFeature;
  final List<String> image;
  final String? floorplan;
  final String? videoLink;
  final String? furnishedType;
  final String? typeOfLet;
  final String createdAt;
  final int livingRoom;
  final String? updatedAt;
  final String? state;
  final bool liked;

  Properties({
    required this.id,
    required this.agentId,
    required this.propertyType,
    required this.propertyFor,
    required this.price,
    required this.status,
    required this.address1,
    this.location,
    this.postcode,
    this.currency = 'NGN', // Default currency
    this.pricePerPcm,
    this.pricePerPa,
    this.availableFrom,
    required this.isTrending,
    required this.bedroom,
    required this.bathroom,
    required this.description,
    this.advanceFeature,
    required this.image,
    this.floorplan,
    this.videoLink,
    this.furnishedType,
    this.typeOfLet,
    required this.createdAt,
    required this.livingRoom,
    this.updatedAt,
    this.state,
    this.liked = false,
  });

  factory Properties.fromMap(Map<String, dynamic> map) {
    return Properties(
      id: map['id'] as int,
      agentId: map['agent_id'].toString(),
      propertyType: map['property_type']?.toString() ?? '',
      propertyFor: map['property_for'] == 2
          ? 'For Sale'
          : map['property_for'] == 1
          ? 'To Lease'
          : 'Unknown',
      price: double.parse((map['price'] as num).toStringAsFixed(0)),
      status: map['status'].toString(),
      address1: map['address1'] ?? '',
      location: map['location'],
      postcode: map['postcode'],
      currency: map['currency'] ?? 'NGN',
      pricePerPcm: (map['price_per_pcm'] as num?)?.toDouble(),
      pricePerPa: (map['price_per_pa'] as num?)?.toDouble(),
      availableFrom: map['available_from'],
      isTrending: map['is_trending'] ?? false,
      bedroom: map['bedroom'] as int? ?? 0,
      bathroom: map['bathroom'] as int? ?? 0,
      description: map['description'] ?? '',
      advanceFeature: map['advance_feature']?.toString(),
      image: (map['image'] as List<dynamic>).cast<String>(),
      floorplan: map['floorplan'],
      videoLink: map['video_link'],
      furnishedType: map['furnished_type'],
      typeOfLet: map['type_of_let'],
      createdAt: map['created_at'] ?? '',
      livingRoom: map['living_room'] as int? ?? 0,
      updatedAt: map['updated_at'],
      state: map['state'],
      liked: map['liked'] ?? false,
    );
  }
}
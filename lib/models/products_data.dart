class PropertiesModel {
  final int id;
  final String propertyFor;
  final String location;
  final int agentId;
  final String propertyAvailability;
  final int propertyType;
  final double price;
  final String livingRoom;
  final String bathroom;
  final String bedroom;
  final bool finance;
  final List<String> amenities;
  final String description;
  final List<String> image;
  final List<String> floorplan;
  final List<String> videoLink;
  final String updatedAt;
  final String createdAt;


  PropertiesModel(
      {
        required this.agentId,
        required this.propertyAvailability,
        required this.finance,
        required this.amenities,
        required this.createdAt,
        required this.id,
        required this.propertyFor,
        required this.location,
        required this.price,
        required this.livingRoom,
        required this.bathroom,
        required this.bedroom,
        required this.description,
        required this.propertyType,
        required this.image,
        required this.floorplan,
        required this.videoLink,
        required this.updatedAt,
      });

  // Define the 'fromMap' method
  factory PropertiesModel.fromMap(Map<String, dynamic> map) {
    return PropertiesModel(
      id: map['id'] ?? 0,
      propertyFor: map['type'] ?? '',
      location: map['location'] ?? '',
      agentId: map['agent_id'] ?? 0,
      propertyAvailability: map['property_availability'] ?? '',
      propertyType: map['property_type_id'] ?? 0,
      price: double.tryParse(map['price']) ?? 0,
      livingRoom: map['living_room'] ?? "",
      bathroom: map['bathroom'] ?? "",
      bedroom: map['bedroom'] ?? "",
      finance: map['finance']  == true,
      amenities: (map['amenities'] as List?)?.map((e) => e.toString()).toList() ?? [],
      description: map['property_description'] ?? '',
      image: List<String>.from(map['property_images'] ?? []),
      floorplan: List<String>.from(map['floor_plan'] ?? []),
      videoLink: List<String>.from(map['video_upload'] ?? []),
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  // Optional: Keep 'fromJson' for consistency if it's used elsewhere
  factory PropertiesModel.fromJson(Map<String, dynamic> json) =>
      PropertiesModel.fromMap(json);


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': propertyFor,
      'location': location,
      'agent_id': agentId,
      'property_availability': propertyAvailability,
      'property_type_id': propertyType,
      'price': price.toString(), // Convert to string if needed
      'living_room': livingRoom,
      'bathroom': bathroom,
      'bedroom': bedroom,
      'finance': finance,
      'amenities': amenities,
      'property_description': description,
      'property_images': image,
      'floor_plan': floorplan,
      'video_upload': videoLink,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

}
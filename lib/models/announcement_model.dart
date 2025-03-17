class Announcement {
  final int id;
  final String announcementText;
  final String redirectLink;

  Announcement({
    required this.id,
    required this.announcementText,
    required this.redirectLink,
  });

  // Factory method to create an instance from JSON
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? 0,
      announcementText: json['announcement_text'] ?? '',
      redirectLink: json['redirect_link'] ?? '',
    );
  }
}
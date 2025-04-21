import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomBanner {
   DateTime? startDate;
   DateTime? endDate;
   String title;
   String content;
   String imageUrl;
   bool isVisible;
   int courseIdForAccessCheck;
   int courseIdForOrderPage;
   int? seqId;
   String? webPageUrl;
   String? webPageTitle;
   String? ctaText;


  CustomBanner({
     this.startDate,
     this.endDate,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.isVisible,
    required this.courseIdForAccessCheck,
    required this.courseIdForOrderPage,
    required this.seqId,
    required this.webPageUrl,
    required this.webPageTitle,
    required this.ctaText,
  });

  // Custom method to parse date strings or Firestore Timestamps
  static DateTime parseDate(dynamic date) {
    if (date is Timestamp) {
      // If the date is a Firestore Timestamp, convert to DateTime
      return date.toDate();
    } else if (date is String) {
      // Remove "at " part for compatibility with DateFormat
      date = date.replaceFirst("at ", "");
      // Define the format for parsing
      DateFormat format = DateFormat("MMMM d, yyyy h:mm:ss a 'UTC'xxx");
      return format.parse(date, true); // 'true' respects timezone
    } else {
      throw FormatException("Invalid date format");
    }
  }

   factory CustomBanner.fromJson(Map<String, dynamic> json) {
     return CustomBanner(
       startDate: json['startDate'] != null ? parseDate(json['startDate']) : null,
       endDate: json['endDate'] != null ? parseDate(json['endDate']) : null,
       title: json['title'],
       content: json['content'],
       imageUrl: json['imageUrl'],
       isVisible: json['isVisible'],
       courseIdForAccessCheck: json['courseIdForAccessCheck'],
       courseIdForOrderPage: json['courseIdForOrderPage'],
       seqId: json['seqId'],
       ctaText: json['ctaText'],
       webPageUrl: json['webPageUrl'],
       webPageTitle: json['webPageTitle'],
     );
   }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'isVisible':isVisible,
      'courseIdForAccessCheck':courseIdForAccessCheck,
      'courseIdForOrderPage':courseIdForOrderPage,
      'seqId':seqId,
      'ctaText':ctaText,
      'webPageUrl': webPageUrl,
      'webPageTitle': webPageTitle,
    };
  }
}

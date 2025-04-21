import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:neetprep_essential/app_state.dart';

class S3FileUploader {


  /// Uploads a file to S3
  ///
  /// [file] is the file to be uploaded
  /// [folder] is the destination folder in the S3 bucket
  ///
  /// Returns the URL of the uploaded file
  /// Throws an [Exception] if an error occurs during the upload
  Future<String> uploadFile(PlatformFile file, String folder) async {
    try {
      // Extract file name and type
      final fileName = file.name;
      final fileType = file.extension;
      // Generate a unique file name
     // final uniqueFileName = '${fileName}_${DateTime.now().millisecondsSinceEpoch}.$fileType';
      final fileBytes = file.bytes ?? await File(file.path!).readAsBytes();
      // Make the POST request to get the signed URL
      final response = await http.post(
        Uri.parse('${FFAppState().baseUrl}/newui/api/s3Upload'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fileName': fileName,
          'fileType': fileType,
          'folder': folder,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get signed URL: ${response.body}');
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final signedRequest = responseBody['signedRequest'];
      final fileUrl = responseBody['url'];

      if (signedRequest == null || fileUrl == null) {
        throw Exception("S3 upload response does not contain 'signedRequest' or 'url'");
      }

      // Upload the file to S3
      final uploadResponse = await http.put(
        Uri.parse(signedRequest),
        headers: {'Content-Type': file.extension??""},
        body: fileBytes,
      );
      print("file.bytes.toString() "+ file.bytes.toString());

      if (uploadResponse.statusCode != 200) {
        throw Exception('Failed to upload file to S3: ${uploadResponse.body}');
      }

      print('File uploaded successfully to S3: $fileUrl');


      // Return the file URL
      return fileUrl;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}

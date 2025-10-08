import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'ddxgbymvn', // Your cloud name
    'Cloudinary_Foodpost', // Your upload preset
    cache: false,
  );

  Future<String> uploadFile(File file) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          resourceType: CloudinaryResourceType.Image,
          // Removed the folder parameter
        ),
      );
      return response.secureUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImageBytes(
    Uint8List imageBytes, {
    String folder = '',
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/ddxgbymvn/image/upload',
      );

      var request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'upload.jpg',
        ),
      );

      request.fields['upload_preset'] = 'Cloudinary_Foodpost';
      if (folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = String.fromCharCodes(responseData);
      final jsonResponse = json.decode(result);

      if (jsonResponse['secure_url'] != null) {
        return jsonResponse['secure_url'];
      } else {
        throw Exception("Upload failed: ${jsonResponse.toString()}");
      }
    } catch (e) {
      print('Cloudinary upload error: $e');
      rethrow;
    }
  }
}

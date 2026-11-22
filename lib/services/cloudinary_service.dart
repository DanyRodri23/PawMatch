import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/dr4cnpg6a/image/upload',
    );

    var request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields['upload_preset'] =
        'pawmatch_upload';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response =
        await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(
        await response.stream.bytesToString(),
      );

      return data['secure_url'];
    }

    return null;
  }

  /// Sube cualquier archivo. [resourceType]: "image" o "video" (el audio también va como "video").
  static Future<String?> uploadMedia(
    File file, {
    String resourceType = 'image',
  }) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/dr4cnpg6a/$resourceType/upload',
    );

    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = 'pawmatch_upload';
    request.files.add(
      await http.MultipartFile.fromPath('file', file.path),
    );

    final response = await request.send().timeout(
          const Duration(seconds: 120),
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      return data['secure_url'];
    }
    return null;
  }
}

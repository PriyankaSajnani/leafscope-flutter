import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantNetApi {
  final String apiKey;
  PlantNetApi(this.apiKey);

  Future<PlantIdentification> identifyPlant(File imageFile) async {
    final uri = Uri.parse(
      'https://my-api.plantnet.org/v2/identify/all?api-key=2b109l45yBUG8U0R0datarvu7u',
    );

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('images', imageFile.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception('Error from API: ${response.statusCode} ${response.body}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return PlantIdentification.fromJson(data);
  }
}

class PlantIdentification {
  final String name;
  final double score;

  PlantIdentification({required this.name, required this.score});

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>;
    if (results.isEmpty) {
      return PlantIdentification(name: 'Unknown plant', score: 0);
    }
    final first = results.first as Map<String, dynamic>;
    final species = first['species'] as Map<String, dynamic>;
    final scientificName = species['scientificName'] as String;
    final score = (first['score'] as num).toDouble();
    return PlantIdentification(name: scientificName, score: score);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:food_dash_app/features/food/model/location_details.dart';
import 'package:food_dash_app/features/food/repo/api.dart';
import 'package:http/http.dart' as http;

class PlaceApiService {
  PlaceApiService(this.sessionToken);

  final String sessionToken;
  final String apiKey = GOOGLE_API_kEY;

  http.Request createGetRequest(String url) {
    return http.Request('GET', Uri.parse(url));
  }

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=$input&components=country:ng&key=$apiKey'
        '&sessiontoken=$sessionToken&radius=50000';
    // '&strictbounds=true&types=geocode';

    http.Request request = createGetRequest(url);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final String data = await response.stream.bytesToString();
      final Map<String, dynamic> result = json.decode(data);

      log(result.toString());

      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description'],
                p['structured_formatting']['main_text']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw result['error_message'] ?? result['status'];
    } else {
      throw 'Failed to fetch suggestion';
    }
  }

  // Future<PlaceDetail> getPlaceDetailFromId(String placeId) async {
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,name,geometry/location&key=$apiKey&sessiontoken=$sessionToken';
  //   var request = createGetRequest(url);
  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     final data = await response.stream.bytesToString();
  //     final result = json.decode(data);
  //     print(result);

  //     if (result['status'] == 'OK') {
  //       // build result
  //       final place = PlaceDetail();
  //       place.address = result['result']['formatted_address'];
  //       place.latitude = result['result']['geometry']['location']['lat'];
  //       place.longitude = result['result']['geometry']['location']['lng'];
  //       place.name = result['result']['geometry']['name'];
  //       return place;
  //     }
  //     throw result['error_message'];
  //   } else {
  //     throw 'Failed to fetch suggestion';
  //   }
  // }
}

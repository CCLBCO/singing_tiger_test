import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';

class APIService {

  //Constructor
  APIService({required this.artistName});

  String artistName;


  // Base API request to get response
  Future<dynamic> get({required String endpoint, required Map<String, String> query}) async {
    // API key
    const _api_key = '3adb15db4cmsh86fc7b52f545f07p162563jsn44fafc528771';
    // Base API url
    String _baseUrl = "https://genius.p.rapidapi.com/search?q=" + artistName;
    // Base headers for Response url
    Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": "genius.p.rapidapi.com",
      "x-rapidapi-key": _api_key,
    };

    Uri uri = Uri.https(_baseUrl, endpoint, query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '/constants.dart';

class TestRun extends StatefulWidget {
  const TestRun({Key? key}) : super(key: key);

  @override
  _TestRunState createState() => _TestRunState();
}



var random = new Random();
class _TestRunState extends State<TestRun> {


  Future<int> getArtistID({required String artistName}) async {
    //var artistName = "Taylor Swift";

    // Base API url
    var searchArtist = artistName
        .replaceAll(" ", "%20")
        .replaceAll('&', '%26')
        .replaceAll('?', '%3F')
        .replaceAll(':', '%3FA');

    // https://genius.p.rapidapi.com/search?q=Taylor%20Swift&rapidapi-key=3adb15db4cmsh86fc7b52f545f07p162563jsn44fafc528771
    Uri searchPath = Uri.parse('https://genius.p.rapidapi.com/search?'
        'q=$searchArtist'
        '&rapidapi-key=$kApi_key');
    http.Response searchResponse = await http.get(searchPath);


    if (searchResponse.statusCode == 200) {
      var  searchData = json.decode(searchResponse.body);
      int artistID = searchData['response']['hits'][0]['result']['primary_artist']['id'];
      print("artistID is $artistID");
      return artistID;
    } else {
      return 0;
    }
  }

  Future<int> getSongID() async {
    int artistID = await getArtistID(artistName: "Taylor Swift");
    bool nextPageToggle = random.nextBool();
    int randomSongNumber = random.nextInt(20);
    int randomSongPage = 1;
    int songID;
    String songTitle;
    int? nextPage;
    bool hasNextPage;


    // https://genius.p.rapidapi.com/search?q=Taylor%20Swift&rapidapi-key=3adb15db4cmsh86fc7b52f545f07p162563jsn44fafc528771
    Uri songPath = Uri.parse('https://genius.p.rapidapi.com/artists/'
        '$artistID/songs'
        '?page=$randomSongPage'
        '&rapidapi-key=$kApi_key');
    http.Response songResponse = await http.get(songPath);
    var songData = json.decode(songResponse.body);
    nextPage = songData['response']['next_page'];
    hasNextPage = (nextPage != null);

    if (songResponse.statusCode == 200) {
      for (randomSongPage = 1; hasNextPage && nextPageToggle;
      nextPageToggle = random.nextBool()) {
        randomSongPage++;
      }
      int songID = songData['response']['songs'][randomSongNumber]['id'];
      String songTitle = songData['response']['songs'][randomSongNumber]['title'];

      print("song ID is $songID");
      print("song title is $songTitle");
      print("next page is $nextPage");
      return songID;
    } else {
      return 0;
    }
  }

  Future<String> getSongURL() async{
    int songID = await getSongID();

    Uri songPath = Uri.parse('https://genius.p.rapidapi.com/songs/'
        '$songID/'
        '?rapidapi-key=$kApi_key');
    http.Response soundURLResponse = await http.get(songPath);
    var soundData = json.decode(soundURLResponse.body);

    if(soundURLResponse.statusCode == 200){
      String songUrl = soundData['response']['song']['media'][0]['url'];
      print("YT link is: $songUrl");
      return songUrl;
    } else {
      return 'no music hints for you!';
    }

  }

  @override
  Widget build(BuildContext context) {
    getSongID();
    getSongURL();
    return Container();
  }
}

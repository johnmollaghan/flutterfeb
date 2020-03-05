import 'dart:wasm';
import 'package:timezone/timezone.dart';

class Airport {
  String fs;
  String name;
  String city;
  String countryCode;
  String timeZoneRegionName;
  String latitude;
  String longitude;
  String name_ar;
  String city_ar;
  String name_de;
  String city_de;
  String name_es;
  String city_es;
  String name_fr;
  String city_fr;
  String name_ja;
  String city_ja;
  String name_ko;
  String city_ko;
  String name_pt;
  String city_pt;
  String name_zh;
  String city_zh;

  int getAirportTimeInUTC(String timeString, String dateString) {

    return 0;
  }

  Airport(
      this.fs,
      this.name,
      this.city,
      this.countryCode,
      this.timeZoneRegionName,
      this.latitude,
      this.longitude,
      this.name_ar,
      this.city_ar,
      this.name_de,
      this.city_de,
      this.name_es,
      this.city_es,
      this.name_fr,
      this.city_fr,
      this.name_ja,
      this.city_ja,
      this.name_ko,
      this.city_ko,
      this.name_pt,
      this.city_pt,
      this.name_zh,
      this.city_zh);
}

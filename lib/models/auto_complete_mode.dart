class AutoCompleteData {
  late final List<AutoCompleteModel> list;

  AutoCompleteData.fromList(List<dynamic> list) {
    this.list = list.map((item) => AutoCompleteModel.fromJson(item)).toList();
  }
}

class AutoCompleteModel {
  late final String placeId,
      osmId,
      osmType,
      lisence,
      lat,
      long,
      className,
      displayName,
      displayPlace,
      displayAddress;
  late final List<String> boundingbox;
  late final Address address;

  AutoCompleteModel.fromJson(Map<String, dynamic> jsonData) {
    placeId = jsonData['place_id'] ?? '';
    osmId = jsonData['osm_type'] ?? '';
    osmType = jsonData['place_id'] ?? '';
    lisence = jsonData['licence'] ?? '';
    lat = jsonData['lat'] ?? '';
    long = jsonData['lon'] ?? '';
    className = jsonData['class'] ?? '';

    displayName = jsonData['display_name'] ?? '';
    displayAddress = jsonData['display_address'] ?? '';
    displayPlace = jsonData['display_place'] ?? '';
    boundingbox = List.from(jsonData['boundingbox']);
    address = Address.fromjson(jsonData['address']);
  }
}

class Address {
  late final String name, country, state, countryCode;

  Address.fromjson(Map<String, dynamic> jsonData) {
    name = jsonData['name'] ?? '';
    country = jsonData['county'] ?? '';
    state = jsonData['state'] ?? '';
    countryCode = jsonData['country_code'] ?? '';
  }
}

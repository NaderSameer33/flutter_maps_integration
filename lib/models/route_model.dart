class RouteData {
  late final List<RoutModel> route;

  RouteData.fromJson(Map<String, dynamic> json) {
    route = (json['routes'] as List)
        .map((item) => RoutModel.fromJson(item))
        .toList();
  }
}

class RoutModel {
  late final List<RouteLeg> routeLeg;
  late final String weightName;
  late final RoutGemotry routGemotry;

  RoutModel.fromJson(Map<String, dynamic> json) {
    routeLeg = (json['legs'] as List)
        .map((item) => RouteLeg.fromJson(item))
        .toList();

    weightName = json['weight_name'] ?? '';

    routGemotry = RoutGemotry.fromJson(json['geometry']);
  }
}

class RouteLeg {
  late final List<dynamic> step;
  late final double weight;
  late final double duration;
  late final double distance;
  late final String summary;

  RouteLeg.fromJson(Map<String, dynamic> json) {
    step = List.from(json['steps'] ?? []);

    weight = (json['weight'] ?? 0).toDouble();
    duration = (json['duration'] ?? 0).toDouble();
    distance = (json['distance'] ?? 0).toDouble();

    summary = json['summary'] ?? '';
  }
}

class RoutGemotry {
  late final List<List<double>> cordnateRouting;

  RoutGemotry.fromJson(Map<String, dynamic> json) {
    cordnateRouting =
        List.from(
              json['coordinates'],
            )
            .map<List<double>>(
              (e) => [
                e[1],
                e[0],
              ],
            )
            .toList();
  }
}

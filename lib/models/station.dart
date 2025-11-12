import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String stationuuid;
  final String name;
  final String url;
  final String favicon;
  final String tags;
  final int votes;
  final int clickcount;

  const Station({
    required this.stationuuid,
    required this.name,
    required this.url,
    required this.favicon,
    required this.tags,
    required this.votes,
    required this.clickcount,
  });

  @override
  List<Object?> get props => [stationuuid];

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationuuid: json['stationuuid'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Station',
      url: json['url_resolved'] as String? ?? json['url'] as String? ?? '',
      favicon: json['favicon'] as String? ?? '',
      tags: json['tags'] as String? ?? 'N/A',
      votes: json['votes'] as int? ?? 0,
      clickcount: json['clickcount'] as int? ?? 0,
    );
  }
}

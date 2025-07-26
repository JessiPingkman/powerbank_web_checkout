part of 'deep_link_service.dart';

abstract class DeepLinkEvent {
  const factory DeepLinkEvent.products({required final String stationId}) = StationDeepLinkEvent;
}

class StationDeepLinkEvent implements DeepLinkEvent {
  final String stationId;

  const StationDeepLinkEvent({required this.stationId});
}

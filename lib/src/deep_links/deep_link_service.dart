import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web/web.dart' as web;

part 'deep_link_event.dart';

part 'deep_link_listener.dart';

class DeepLinkService {
  static const _stationPath = 'station';
  final _eventHandler = StreamController<DeepLinkEvent>.broadcast();

  Stream<DeepLinkEvent> get stream => _eventHandler.stream;

  void init() {
    if (kIsWeb) {
      _handleInitialWebUri();
      _listenToWebUriChanges();
    }
  }

  void dispose() {
    _eventHandler.close();
  }

  void _handleInitialWebUri() {
    final uri = Uri.base;
    _parseUri(uri);
  }

  void _listenToWebUriChanges() {
    web.window.onPopState.listen((event) {
      final uri = Uri.base;
      _parseUri(uri);
    });
  }

  // http://localhost:62817/#/station/RECH082203000350
  void _parseUri(Uri uri) {
    final fragment = uri.fragment;
    final fragmentUri = Uri.parse(fragment);

    final segments = fragmentUri.pathSegments;

    if (segments.isNotEmpty && segments.first == _stationPath && segments.length >= 2) {
      final stationId = segments[1];
      _eventHandler.add(StationDeepLinkEvent(stationId: stationId));
    }
  }
}

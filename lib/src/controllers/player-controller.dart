import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final betterPlayerControllerProvider = StateProvider.autoDispose<BetterPlayerController>((ref){
  BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
    aspectRatio: 16 / 9,
    fit: BoxFit.contain,
    handleLifecycle: true,
    autoPlay: true,
    autoDetectFullscreenDeviceOrientation: true
  );
  return BetterPlayerController(betterPlayerConfiguration);
});
// final betterPlayerConfigurationProvider = StateProvider.autoDispose<BetterPlayerConfiguration>((ref) => null);
// final betterPlayerDatasourceProvider = StateProvider.autoDispose<BetterPlayerDataSource>((ref) => null);


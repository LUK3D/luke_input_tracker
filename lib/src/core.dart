import 'dart:convert';
import 'package:flutter/services.dart';

import 'models.dart';
import 'rust/api/simple.dart' as api;
import 'rust/frb_generated.dart';

/// # LukeInputTracker
/// A utility class that provides access to native input event tracking
/// through a Rust backend using Flutter Rust Bridge.
///
/// This class handles initialization, permissions, and a stream of events
/// from keyboard, mouse, and button interactions.
class LukeInputTracker {
  /// ## init
  /// Initializes the underlying Rust library required for native input tracking.
  ///
  /// This method must be called before using other methods in [LukeInputTracker],
  /// particularly before starting the listener.
  static Future<void> init() async {
    await RustLib.init();
  }

  /// ## listen
  /// Starts listening for global input events from the operating system.
  ///
  /// Returns a [Stream] of [InputEvent] objects representing keyboard,
  /// mouse, and button interactions captured by the native listener.
  ///
  /// Make sure [init] has been called before using this method.
  static Stream<InputEvent> listen() {
    return api.startGlobalListener().asyncMap(
      (data) => InputEvent.fromJson(jsonDecode(data)),
    );
  }

  /// ## isAccessibilityPermissionGranted
  /// Checks whether the app has the required accessibility permissions
  /// to capture global input events (macOS only).
  ///
  /// Returns `true` if permission has been granted, or `false` otherwise.
  static Future<bool> isAccessibilityPermissionGranted() async {
    return await api.isAccessibilityPermissionGranted();
  }

  static Future<void> sendKeyPress(TrackerKey key)async{
   await api.sendEvent(eventType: EventType.keyPress.value, value: key.toInt());
  }

  static Future<void> sendKeyRelease(TrackerKey key)async{
   await  api.sendEvent(eventType: EventType.keyRelease.value, value: key.toInt());
  }

  static Future<void> sendMouseButtonPress(TrackerButton button)async{
   await  api.sendEvent(eventType: EventType.buttonPress.value, value: button.value);
  }

  static Future<void> sendMouseButtonRelease(TrackerButton button)async{
   await  api.sendEvent(eventType: EventType.buttonRelease.value, value: button.value);
  }

   static Future<void> sendMouseMove(Offset position)async{
   await  api.sendEvent(eventType: EventType.mouseMove.value, value: 0, mouseX: position.dx, mouseY: position.dy);
  }
}

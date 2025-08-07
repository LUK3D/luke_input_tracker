/// # InputEventType
/// Enum representing the type of an input event.
enum InputEventType {
  /// Mouse moved (with x/y coordinates in data).
  mouseMove,

  /// A keyboard key was pressed (with key name in data).
  keyPress,

  /// A keyboard key was released (with key name in data).
  keyRelease,

  /// A mouse button was pressed (with button name in data).
  buttonPress,

  /// A mouse button was released (with button name in data).
  buttonRelease,

  /// An unknown event type that couldn’t be mapped.
  unknown;

  /// ## fromString
  /// Creates an [InputEventType] from a [String] value.
  ///
  /// If the value does not match any known type, returns [InputEventType.unknown].
  static InputEventType fromString(String value) {
    switch (value) {
      case 'MouseMove':
        return InputEventType.mouseMove;
      case 'KeyPress':
        return InputEventType.keyPress;
      case 'KeyRelease':
        return InputEventType.keyRelease;
      case 'ButtonPress':
        return InputEventType.buttonPress;
      case 'ButtonRelease':
        return InputEventType.buttonRelease;
      default:
        return InputEventType.unknown;
    }
  }

  /// ## toJson
  /// Converts this enum to its corresponding [String] value for JSON serialization.
  String toJson() {
    switch (this) {
      case InputEventType.mouseMove:
        return 'MouseMove';
      case InputEventType.keyPress:
        return 'KeyPress';
      case InputEventType.keyRelease:
        return 'KeyRelease';
      case InputEventType.buttonPress:
        return 'ButtonPress';
      case InputEventType.buttonRelease:
        return 'ButtonRelease';
      case InputEventType.unknown:
        return 'Unknown';
    }
  }
}


/// # InputEvents
/// Represents an input event captured from the system.
///
/// Each input event includes a timestamp, optional source name, event type,
/// 
/// and a generic [data] map which holds additional event-specific data.
/// 
/// Example:
/// ```json
/// {
///   "time": 1722964070123,
///   "name": "X11",
///   "type": "KeyPress",
///   "data": {
///     "key": "A"
///   }
/// }
/// ```
class InputEvent {
  /// The timestamp when the event occurred.
  final DateTime time;

  /// Optional name of the source device (e.g., `X11`, `Wayland`, etc).
  final String? name;

  /// The type of input event (e.g. key press, mouse move, etc).
  final InputEventType type;

  /// ## data
  /// Additional event-specific data.
  ///
  /// - For `MouseMove`, contains: `{ "x": double, "y": double }`
  /// - For `KeyPress`/`KeyRelease`, contains: `{ "key": String }`
  /// - For `ButtonPress`/`ButtonRelease`, contains: `{ "button": String }`
  final Map<String, dynamic> data;

  /// ## InputEvent
  /// Creates an [InputEvent] instance.
  InputEvent({
    required this.time,
    required this.type,
    required this.data,
    this.name,
  });

  /// ## fromJson
  /// Creates an [InputEvent] instance from a JSON map.
  factory InputEvent.fromJson(Map<String, dynamic> json) {
    return InputEvent(
      time: DateTime.fromMillisecondsSinceEpoch(
        json['time'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      name: json['name'],
      type: InputEventType.fromString(json['type']),
      data: Map<String, dynamic>.from(json['data']),
    );
  }

  /// ## toJson
  /// Converts this [InputEvent] into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'time': time.millisecondsSinceEpoch,
      'name': name,
      'type': type.toJson(),
      'data': data,
    };
  }

  @override
  String toString() {
    return 'InputEvent(time: $time, name: $name, type: $type, data: $data)';
  }
}

enum TrackerKey {
  alt,
  altGr,
  backspace,
  capsLock,
  controlLeft,
  controlRight,
  delete,
  downArrow,
  end,
  escape,
  f1,
  f10,
  f11,
  f12,
  f13,
  f14,
  f15,
  f16,
  f17,
  f18,
  f19,
  f20,
  f21,
  f22,
  f23,
  f24,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,
  f9,
  home,
  leftArrow,
  metaLeft,
  metaRight,
  pageDown,
  pageUp,
  returnKey,
  rightArrow,
  shiftLeft,
  shiftRight,
  space,
  tab,
  upArrow,
  printScreen,
  scrollLock,
  pause,
  numLock,
  backQuote,
  num1,
  num2,
  num3,
  num4,
  num5,
  num6,
  num7,
  num8,
  num9,
  num0,
  minus,
  equal,
  keyQ,
  keyW,
  keyE,
  keyR,
  keyT,
  keyY,
  keyU,
  keyI,
  keyO,
  keyP,
  leftBracket,
  rightBracket,
  keyA,
  keyS,
  keyD,
  keyF,
  keyG,
  keyH,
  keyJ,
  keyK,
  keyL,
  semiColon,
  quote,
  backSlash,
  intlBackslash,
  keyZ,
  keyX,
  keyC,
  keyV,
  keyB,
  keyN,
  keyM,
  comma,
  dot,
  slash,
  insert,
  kpReturn,
  kpMinus,
  kpPlus,
  kpMultiply,
  kpDivide,
  kp0,
  kp1,
  kp2,
  kp3,
  kp4,
  kp5,
  kp6,
  kp7,
  kp8,
  kp9,
  kpDelete,
  function,
  volumeUp,
  volumeDown,
  volumeMute,
  brightnessUp,
  brightnessDown,
  previousTrack,
  playPause,
  playCd,
  nextTrack,
  unknown;

  static TrackerKey fromInt(int value) {
    if (value >= 0 && value < TrackerKey.values.length - 1) {
      return TrackerKey.values[value];
    }
    return TrackerKey.unknown;
  }

  int toInt() {
    return TrackerKey.values.indexOf(this);
  }
}

/// # Button
/// Represents mouse buttons.
enum TrackerButton {
  left(0),
  right(1),
  middle(2),
  unknown(3);

  final int value;

  const TrackerButton(this.value);

  /// Returns the [TrackerButton] enum variant from an integer value.
  static TrackerButton fromInt(int value) {
    switch (value) {
      case 0:
        return TrackerButton.left;
      case 1:
        return TrackerButton.right;
      case 2:
        return TrackerButton.middle;
      case 3:
      default:
        return TrackerButton.unknown;
    }
  }
}

enum EventType {
  buttonPress(0),
  buttonRelease(1), 
  keyPress(2),
  keyRelease(3),
  mouseMove(4);

  final int value;
  const EventType(this.value);
}

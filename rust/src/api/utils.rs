use std::time::{Duration, UNIX_EPOCH};

use rdev::{Button, EventType, Key};
use regex::Regex;
use serde_json::{json, Value};

pub fn parse_event_string(input: &str) -> Option<String> {
    let time_re = Regex::new(r"tv_sec: (\d+), tv_nsec: (\d+)").ok()?;
    let name_re = Regex::new(r"name: (.*?), event_type").ok()?;

    // Extract time
    let time_caps = time_re.captures(input)?;
    let sec = time_caps.get(1)?.as_str().parse::<u64>().ok()?;
    let nsec = time_caps.get(2)?.as_str().parse::<u32>().ok()?;
    let time = UNIX_EPOCH + Duration::new(sec, nsec);
    let time_ms = time.duration_since(UNIX_EPOCH).ok()?.as_millis();

    // Extract name
    let name_caps = name_re.captures(input)?;
    let name_str = name_caps.get(1)?.as_str().trim();
    let name_value = if name_str == "None" {
        Value::Null
    } else {
        Value::String(name_str.trim_matches('"').to_string())
    };

    // Match event types
    let result = if let Some(caps) = Regex::new(r"MouseMove \{ x: ([\d.]+), y: ([\d.]+) \}").ok()?.captures(input) {
        let x = caps.get(1)?.as_str().parse::<f64>().ok()?;
        let y = caps.get(2)?.as_str().parse::<f64>().ok()?;
        json!({
            "time": time_ms,
            "name": name_value,
            "type": "MouseMove",
            "data": { "x": x, "y": y },
            "auto_builded": true,
        })
    } else if let Some(caps) = Regex::new(r"KeyPress\((\w+)\)").ok()?.captures(input) {
        let key = caps.get(1)?.as_str();
        json!({
            "time": time_ms,
            "name": name_value,
            "type": "KeyPress",
            "data": { "key": key }
        })
    } else if let Some(caps) = Regex::new(r"KeyRelease\((\w+)\)").ok()?.captures(input) {
        let key = caps.get(1)?.as_str();
        json!({
            "time": time_ms,
            "name": name_value,
            "type": "KeyRelease",
            "data": { "key": key }
        })
    } else if let Some(caps) = Regex::new(r"ButtonPress\((\w+)\)").ok()?.captures(input) {
        let button = caps.get(1)?.as_str();
        json!({
            "time": time_ms,
            "name": name_value,
            "type": "ButtonPress",
            "data": { "button": button }
        })
    } else if let Some(caps) = Regex::new(r"ButtonRelease\((\w+)\)").ok()?.captures(input) {
        let button = caps.get(1)?.as_str();
        json!({
            "time": time_ms,
            "name": name_value,
            "type": "ButtonRelease",
            "data": { "button": button }
        })
    } else {
        return None;
    };

    Some(result.to_string())
}


pub fn key_from_u32(value: u32) -> Key {
    use Key::*;
    match value {
        0 => Alt,
        1 => AltGr,
        2 => Backspace,
        3 => CapsLock,
        4 => ControlLeft,
        5 => ControlRight,
        6 => Delete,
        7 => DownArrow,
        8 => End,
        9 => Escape,
        10 => F1,
        11 => F10,
        12 => F11,
        13 => F12,
        14 => F13,
        15 => F14,
        16 => F15,
        17 => F16,
        18 => F17,
        19 => F18,
        20 => F19,
        21 => F20,
        22 => F21,
        23 => F22,
        24 => F23,
        25 => F24,
        26 => F2,
        27 => F3,
        28 => F4,
        29 => F5,
        30 => F6,
        31 => F7,
        32 => F8,
        33 => F9,
        34 => Home,
        35 => LeftArrow,
        36 => MetaLeft,
        37 => MetaRight,
        38 => PageDown,
        39 => PageUp,
        40 => Return,
        41 => RightArrow,
        42 => ShiftLeft,
        43 => ShiftRight,
        44 => Space,
        45 => Tab,
        46 => UpArrow,
        47 => PrintScreen,
        48 => ScrollLock,
        49 => Pause,
        50 => NumLock,
        51 => BackQuote,
        52 => Num1,
        53 => Num2,
        54 => Num3,
        55 => Num4,
        56 => Num5,
        57 => Num6,
        58 => Num7,
        59 => Num8,
        60 => Num9,
        61 => Num0,
        62 => Minus,
        63 => Equal,
        64 => KeyQ,
        65 => KeyW,
        66 => KeyE,
        67 => KeyR,
        68 => KeyT,
        69 => KeyY,
        70 => KeyU,
        71 => KeyI,
        72 => KeyO,
        73 => KeyP,
        74 => LeftBracket,
        75 => RightBracket,
        76 => KeyA,
        77 => KeyS,
        78 => KeyD,
        79 => KeyF,
        80 => KeyG,
        81 => KeyH,
        82 => KeyJ,
        83 => KeyK,
        84 => KeyL,
        85 => SemiColon,
        86 => Quote,
        87 => BackSlash,
        88 => IntlBackslash,
        89 => KeyZ,
        90 => KeyX,
        91 => KeyC,
        92 => KeyV,
        93 => KeyB,
        94 => KeyN,
        95 => KeyM,
        96 => Comma,
        97 => Dot,
        98 => Slash,
        99 => Insert,
        100 => KpReturn,
        101 => KpMinus,
        102 => KpPlus,
        103 => KpMultiply,
        104 => KpDivide,
        105 => Kp0,
        106 => Kp1,
        107 => Kp2,
        108 => Kp3,
        109 => Kp4,
        110 => Kp5,
        111 => Kp6,
        112 => Kp7,
        113 => Kp8,
        114 => Kp9,
        115 => KpDelete,
        116 => Function,
        117 => VolumeUp,
        118 => VolumeDown,
        119 => VolumeMute,
        120 => BrightnessUp,
        121 => BrightnessDown,
        122 => PreviousTrack,
        123 => PlayPause,
        124 => PlayCd,
        125 => NextTrack,
        _ => Unknown(value),
    }
}

pub fn event_type_from_int(event_type: u8, value: u32, mouse_x: Option<f64>, mouse_y: Option<f64>) -> Option<EventType> {
    match event_type {
        0 => Some(EventType::ButtonPress(button_from_u8(value as u8))),
        1 => Some(EventType::ButtonRelease(button_from_u8(value as u8))),
        2 => Some(EventType::KeyPress(key_from_u32(value))),
        3 => Some(EventType::KeyRelease(key_from_u32(value))),
        4 => Some(EventType::MouseMove { x: mouse_x.unwrap_or(0.0), y: mouse_y.unwrap_or(0.0) }),
        _ => None
    }
}

pub fn button_from_u8(value: u8) -> Button {
    match value {
        0 => Button::Left,
        1 => Button::Right,
        2 => Button::Middle,
        other => Button::Unknown(other),
    }
}

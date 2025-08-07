use super::permissions;
use crate::frb_generated::StreamSink;
use std::{thread, time};
use rdev::{grab, set_is_main_thread, simulate, Event};
use super::utils;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

#[flutter_rust_bridge::frb]
pub fn start_global_listener(sink: StreamSink<String>) {
    // Spawn a native thread (not Flutter isolate)
    thread::spawn(move || {
        #[cfg(target_os = "macos")]
        set_is_main_thread(false);

        let _ = grab(move |event: Event| {
            println!("{:?}", event);
            if let Some(data) = utils::parse_event_string(format!("{:?}", event).as_str()) {
                if let Err(e) = sink.add(data) {
                    eprintln!("Failed to send event to Dart: {:?}", e);
                }
            }
            Some(event)
        });
    });
}

#[flutter_rust_bridge::frb()]
pub fn is_accessibility_permission_granted() -> bool {
    #[cfg(target_os = "macos")]
    {
        permissions::macos_accessibility::is_accessibility_trusted()
    }
    #[cfg(not(target_os = "macos"))]
    {
        true
    }
}

#[flutter_rust_bridge::frb()]
pub fn send_event(event_type: u8, value: u32, mouse_x: Option<f64>, mouse_y: Option<f64> ) {
    let delay = time::Duration::from_millis(20);
    if let Some(computed_type) = utils::event_type_from_int(event_type, value, mouse_x, mouse_y){
        match simulate(&computed_type) {
            Ok(()) => (),
            Err(err) => {
                println!("We could not send {:?}", err.to_string());
            }
        }
    }
    thread::sleep(delay);
}

enum MouseButton {
    Left,
    Right,
    Middle,
}
enum WindowEvent {
    Mouse {
        btn: MouseButton,
        x: u32,
        y: u32,
    },
    KeyPress(u16),
    FocusLost,
    FocusGained,
}

fn main () {
	let event = WindowEvent::Mouse { btn: MouseButton::Left, x: 20, y: 100 };
	match event {
		WindowEvent::Mouse {
            btn: button @ MouseButton::Left
            |    button @ MouseButton::Right,
            x, y
        } => {
			println!("Mouse {} click at {}, {}", match button {
                MouseButton::Left => "left",
                MouseButton::Right => "right",
                MouseButton::Middle => "middle",
            }, x, y);
		},
		WindowEvent::Mouse { btn: MouseButton::Middle, x, y } => {
			println!("Mouse middle click at {}, {}", x, y);
		},
		WindowEvent::KeyPress(keycode) => {
			println!("Key Press {}", keycode);
		},
		WindowEvent::FocusLost => {
			println!("Focus Lost");
		},
		WindowEvent::FocusGained => {
			println!("Focus Gained");
		},
	}
}

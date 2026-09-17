use rust_template::greeting;

#[test]
fn greeting_returns_expected_message() {
    assert_eq!(greeting(), "Hello from rust-template!");
}

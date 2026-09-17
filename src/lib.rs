//! rust-template library.

/// Returns the crate's greeting message.
#[must_use]
pub fn greeting() -> String {
    "Hello from rust-template!".to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greeting_matches() {
        assert_eq!(greeting(), "Hello from rust-template!");
    }
}

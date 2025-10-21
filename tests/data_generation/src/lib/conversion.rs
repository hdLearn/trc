pub fn to_bin(value: u32, width: u32) -> String {
    format!("{:0width$b}", value, width = width as usize)
}

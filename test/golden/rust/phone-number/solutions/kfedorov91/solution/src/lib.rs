pub fn number(user_number: &str) -> Option<String> {
    let mut nums: Vec<char> = user_number.chars().filter(|c| c.is_numeric()).collect();
    if nums.len() > 11 || nums.len() < 10 {
        return None;
    }
    if nums.len() == 11 && nums[0] != '1' {
        return None;
    }
    if nums.len() == 11 {
        nums.remove(0);
    }
    if nums[0] == '0' || nums[0] == '1' || nums[3] == '0' || nums[3] == '1' {
        return None;
    }
    Some(nums.into_iter().collect())
}

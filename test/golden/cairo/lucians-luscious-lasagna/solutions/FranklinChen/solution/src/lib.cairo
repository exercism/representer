//! <https://exercism.org/tracks/cairo/exercises/lucians-luscious-lasagna>

/// Returns the expected minutes the lasagna should be in the oven.
pub fn expected_minutes_in_oven() -> u32 {
    40
}

/// Calculates the remaining minutes the lasagna needs to be in the oven.
///
/// # Arguments
///
/// * `actual_minutes_in_oven` - The number of minutes the lasagna has already been in the oven.
pub fn remaining_minutes_in_oven(actual_minutes_in_oven: u32) -> u32 {
    expected_minutes_in_oven() - actual_minutes_in_oven
}

/// Calculates the preparation time in minutes for the given number of layers.
///
/// Each layer takes 2 minutes to prepare.
///
/// # Arguments
///
/// * `number_of_layers` - The number of layers in the lasagna.
pub fn preparation_time_in_minutes(number_of_layers: u32) -> u32 {
    number_of_layers * 2
}

/// Calculates the total elapsed time in minutes, including preparation and oven time.
///
/// # Arguments
///
/// * `number_of_layers` - The number of layers in the lasagna.
/// * `actual_minutes_in_oven` - The number of minutes the lasagna has been in the oven.
pub fn elapsed_time_in_minutes(number_of_layers: u32, actual_minutes_in_oven: u32) -> u32 {
    preparation_time_in_minutes(number_of_layers) + actual_minutes_in_oven
}

#include <array>
#include <string>
#include <vector>
#include <algorithm>

// Round down all provided student scores.
std::vector<int> round_down_scores(std::vector<double> student_scores) {
    std::vector<int> result(student_scores.size());
    std::transform(
        student_scores.cbegin(),
        student_scores.cend(),
        result.begin(),
        [](double x){
            return static_cast<int>(x);
        }
    );
    return result;
}


// Count the number of failing students out of the group provided.
int count_failed_students(std::vector<int> student_scores) {
    std::vector<int> result;
    std::copy_if(
        student_scores.cbegin(),
        student_scores.cend(),
        std::back_inserter(result),
        [](int x) {
            return x <= 40;
        }
    );
    return result.size();
}

// Determine how many of the provided student scores were 'the best' based on the provided threshold.
std::vector<int> above_threshold(std::vector<int> student_scores, int threshold) {
    std::vector<int> result;
    std::copy_if(
        student_scores.cbegin(),
        student_scores.cend(),
        std::back_inserter(result),
        [&](int x) {
            return x >= threshold;
        }
    );
    return result;
}

// Create a list of grade thresholds based on the provided highest grade.
std::array<int, 4> letter_grades(int highest_score) {
    int bin_size = (highest_score-40) / 4;
    return {
        41,
        41 + bin_size,
        41 + 2*bin_size,
        41 + 3*bin_size,
    };
}

// Organize the student's rank, name, and grade information in ascending order.
std::vector<std::string> student_ranking(std::vector<int> student_scores, std::vector<std::string> student_names) {
    std::vector<std::string> concatenated;
    size_t index = 1;
    std::transform(
        student_scores.cbegin(),
        student_scores.cend(),
        student_names.cbegin(),
        std::back_inserter(concatenated),
        [&](int score, std::string name) {
            return std::to_string(index++) + ". " + name + ": " + std::to_string(score); 
        }
    );
    
    return concatenated;
}

// Create a string that contains the name of the first student to make a perfect score on the exam.
std::string perfect_score(std::vector<int> student_scores, std::vector<std::string> student_names) {
    // Since we stop at the first occurance, resort to simple loop
    for (size_t i=0; i<student_scores.size(); i++) {
        if (student_scores[i] == 100) {
            return student_names[i];
        }
    }
    return "";
}
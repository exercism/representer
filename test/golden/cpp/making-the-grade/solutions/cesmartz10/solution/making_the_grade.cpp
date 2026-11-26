#include <array>
#include <string>
#include <vector>
#include <algorithm>
#include <cmath>
#include <sstream>

// Round down all provided student scores.
std::vector<int> round_down_scores(std::vector<double> student_scores) {
    std::vector<int> result;    
    for (size_t i = 0; i < student_scores.size(); ++i) {
        result.push_back(static_cast<int>(std::floor(student_scores[i])));
    } 
    return result;
}


// Count the number of failing students out of the group provided.
int count_failed_students(std::vector<int> student_scores) {
    int result = 0;    
    for (size_t i = 0; i < student_scores.size(); ++i) {
        result = student_scores.at(i) <= 40 ? result + 1 : result;
    } 
    return result;
}

// Determine how many of the provided student scores were 'the best' based on the provided threshold.
std::vector<int> above_threshold(std::vector<int> student_scores, int threshold) {
    std::vector<int> result;
    for (size_t i = 0; i < student_scores.size(); ++i) {
        if (student_scores.at(i) >= threshold) {
           result.push_back(student_scores[i]); 
        } 
    } 
    return result;
}

// Create a list of grade thresholds based on the provided highest grade.
std::array<int, 4> letter_grades(int highest_score) {
    int steps = (highest_score - 40) / 4;
    int f = 41;
    int d = f + steps;
    int c = d + steps;
    int b = c + steps;
    
    return {f, d, c, b};
}

// Organize the student's rank, name, and grade information in ascending order.
std::vector<std::string> student_ranking(std::vector<int> student_scores, std::vector<std::string> student_names) {
    std::vector<std::string> result;

    std::string currString;
    for (int i = 0; i < student_scores.size(); i++) {
        std::stringstream ss;
        ss << (i+1) << ". " << student_names.at(i) << ": " << student_scores.at(i);
        currString = ss.str();
        
        result.push_back(currString);
    }
    return result;
}

// Create a string that contains the name of the first student to make a perfect score on the exam.
std::string perfect_score(std::vector<int> student_scores, std::vector<std::string> student_names) {
    
    std::string currString;
    for (int i = 0; i < student_scores.size(); i++) {
        if (student_scores.at(i) == 100) {
            return student_names.at(i);
        }
    }
    return "";
}

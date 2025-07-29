import Foundation

public struct ExamDone {
    let courseCode: String
    let courseName: String
    let date: String
    let cfu: Int
    let ssd: String
    let academicYear: String
    
    let nominalGrade: String
    let numericGrade: Int? // Optional because pass/fail exams might not have a numeric grade
}

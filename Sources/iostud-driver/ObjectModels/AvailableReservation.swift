public struct AvailableReservation {
    let codIdenVerb: Int
    let codAppe: Int
    let codCourseStud: String
    let descCourseStud: String
    let courseName: String
    let cfu: Int
    let channel: String
    let teacher: String
    let faculty: String
    let accYear: String
    let appealDate: String
    let notes: String?
    let startDatePrenotation: String
    let endDatePrenotatation: String
    let didacticModuleCode: String?
    let executionModeList: [ExecutionMode]
    
    public struct ExecutionMode {
        let examType: String
        let examTypeDescription: String
    }
}

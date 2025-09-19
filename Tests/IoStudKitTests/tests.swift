import Testing
@testable import IoStudKit

@Test func sessionTokenGenerator() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    dump("Token: \(ioStud.getSessionToken())")
}

@Test func testStudentBio() async throws {
    let ioStud = IoStud(studentID: secret_maticola, studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    let bio = try await ioStud.retrieveStudentBio()
    dump(bio)
}

@Test func testDoneExams() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    let doneExams = try await ioStud.retrieveDoneExams()
        
    for exam in doneExams {
        dump(exam)
    }
}

@Test func testDoableExams() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    let doableExams = try await ioStud.retrieveDoableExams()

    for exam in doableExams {
        dump(exam)
    }
}

@Test func testActiveReservations() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    var activeReservations = try await ioStud.retrieveActiveReservations()

    activeReservations.sort(by: {$0.appealDate<$1.appealDate})
    var counter = 0
    for reservation in activeReservations {
        print("Reservation \(counter):\n \t - corso:\(reservation.courseName)\n \t - canale:\(reservation.channel)\n \t - data:\(reservation.appealDate)\n \t - nota: \(reservation.notes ?? "")\n")
        
        counter += 1
    }
}

@Test func testAvailableReservations() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    let doableExams = try await ioStud.retrieveDoableExams()
    
    var availableReservationList = [AvailableReservation]()
    for exam in doableExams {
        let availableReservations = try await ioStud.retrieveAvailableReservations(for: exam)
        availableReservationList.append(contentsOf: availableReservations)
    }
    
    availableReservationList.sort(by: {$0.appealDate<$1.appealDate})
    
    var counter = 0
    for reservation in availableReservationList {
        print("Reservation \(counter):\n \t - corso:\(reservation.courseName)\n \t - canale:\(reservation.channel)\n \t - data:\(reservation.appealDate)\n \t - nota: \(reservation.notes ?? "")\n")
        print("----- ----- -----\n")
        counter += 1
    }
}

@Test func testInsertReservation() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    let doableExams = try await ioStud.retrieveDoableExams()
    var availableReservationList = [AvailableReservation]()
    
    for exam in doableExams {
        let availableReservations = try await ioStud.retrieveAvailableReservations(for: exam)
        availableReservationList.append(contentsOf: availableReservations)
    }
    
    availableReservationList.sort(by: {$0.appealDate < $1.appealDate})
    
    let reservationIndex = 999
    let selecedReservation = availableReservationList[reservationIndex]
    
    try await ioStud.insertReservation(for: selecedReservation, attendingMode: selecedReservation.AttendingModeList[0])
}

@Test func testDeleteReservation() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    try await ioStud.doLogin()
    
    var activeReservations = try await ioStud.retrieveActiveReservations()
    activeReservations.sort(by: {$0.appealDate<$1.appealDate})
    
    let reservationIndex = 999999
    let selecedReservation = activeReservations[reservationIndex]
    
    try await ioStud.deleteReservation(for: selecedReservation)
}

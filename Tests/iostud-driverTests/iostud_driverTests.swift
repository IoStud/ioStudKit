import Testing
@testable import iostud_driver

@Test func sessionTokenGenerator() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    await ioStud.refreshSessionToken()
    
    print("Token: \(ioStud.getSessionToken()) <--- copy this token and paste it into the secret_token empty string in secret.swift")
}

@Test func testStudentBio() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    if secret_token.isEmpty {
        print("Error: Missing session token\n - Follow instructions in how_to_test.md to generate a session token")
    } else {
        ioStud.setSessionToken(token: secret_token)
    }
    
    guard let bio = await ioStud.retrieveStudentBio() else {
        print("Error while fetching student bio")
        return
    }
    
    print(bio)
}

@Test func testDoneExams() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    if secret_token.isEmpty {
        print("Error: Missing session token\n - Follow instructions in how_to_test.md to generate a session token")
    } else {
        ioStud.setSessionToken(token: secret_token)
    }
    
    guard let doneExams = await ioStud.retrieveDoneExams() else {
        print("Error while fetching done exams")
        return
    }
        
    print("\n\n---------------- DONE EXAMS ----------------")
    for exam in doneExams {
        print(exam)
        print("----- ----- -----")
    }
}

@Test func testDoableExams() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    if secret_token.isEmpty {
        print("Error: Missing session token\n - Follow instructions in how_to_test.md to generate a session token")
    } else {
        ioStud.setSessionToken(token: secret_token)
    }
    
    guard let doableExams = await ioStud.retrieveDoableExams() else {
        print("Error while fetching doable exams")
        return
    }

    print("\n\n---------------- DOABLE EXAMS ----------------")
    for exam in doableExams {
        print(exam)
        print("----- ----- -----")
    }
}

@Test func testActiveReservations() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    if secret_token.isEmpty {
        print("Error: Missing session token\n - Follow instructions in how_to_test.md to generate a session token")
    } else {
        ioStud.setSessionToken(token: secret_token)
    }
    
    guard let availableReservations = await ioStud.retrieveActiveReservations() else {
        print("Error while fetching available reservations")
        return
    }

    for reservation in availableReservations {
        print(reservation)
        print("----- ----- -----")
    }
}

@Test func testAvailableReservations() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    if secret_token.isEmpty {
        print("Error: Missing session token\n - Follow instructions in how_to_test.md to generate a session token")
    } else {
        ioStud.setSessionToken(token: secret_token)
    }
    
    guard let doableExams = await ioStud.retrieveDoableExams() else {
        print("Error while fetching doable exams")
        return
    }
    var availableReservationList = [AvailableReservation]()
    
    for exam in doableExams {
        guard let availableReservations = await ioStud.retrieveAvailableReservations(for: exam) else {
            print("Error while fetching available reservations")
            return
        }
        availableReservationList.append(contentsOf: availableReservations)
    }
    availableReservationList.sort(by: {$0.appealDate<$1.appealDate})
    
    var counter = 0
    for reservation in availableReservationList {
        print("Reservation \(counter):\n \t - corso:\(reservation.courseName)\n \t - canale:\(reservation.channel)\n \t - data:\(reservation.appealDate)\n \t - nota: \(reservation.notes ?? "")\n\(reservation)")
        print("----- ----- -----\n")
        counter += 1
    }
}


@Test func testInsertReservation() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPassword: secret_pw)
    
    if secret_token.isEmpty {
        print("Error: Missing session token\n - Follow instructions in how_to_test.md to generate a session token")
    } else {
        ioStud.setSessionToken(token: secret_token)
    }
    
    guard let availableReservations = await ioStud.retrieveActiveReservations() else {
        print("Error while fetching available reservations")
        return
    }
    
    var counter = 0
    for reservation in availableReservations {
        print("Reservation: \(counter): \(reservation)")
        print("----- ----- -----")
    }
    
    print("Please enter a number:", terminator: " ")
    guard let line = readLine(),
          let number = Int(line)
    else {
        print("Invalid input—please enter a valid integer.")
        return
    }
}

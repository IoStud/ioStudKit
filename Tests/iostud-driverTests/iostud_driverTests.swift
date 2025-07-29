import Testing
@testable import iostud_driver

@Test func testStudentBio() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPwd: secret_pw)
    
    await ioStud.doLogin()
    
    guard let token = try? ioStud.getSessionToken() else {
        return
    }
    
    print("Token:\(token)")
    
    guard let bio = await ioStud.retrieveStudentBio() else {
        print("Errore bio")
        return
    }
    
    print(bio)
}

@Test func testDoneExams() async throws {
    let ioStud = IoStud(studentID: secret_maticola , studentPwd: secret_pw)
    
    await ioStud.doLogin()
    
    guard let token = try? ioStud.getSessionToken() else {
        return
    }
    
    print("Token:\(token)")
        
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
    
    let ioStud = IoStud(studentID: secret_maticola , studentPwd: secret_pw)
    await ioStud.doLogin()
    guard let token = try? ioStud.getSessionToken() else {
        return
    }
    print("Token:\(token)")
        
    
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

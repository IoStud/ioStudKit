import Testing
@testable import iostud_driver

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let ioStud = IoStud(studentID: secret_maticola , studentPwd: secret_pw)
    
    await ioStud.doLogin()
    
    guard let token = try? ioStud.getSessionToken() else {
        return
    }
    
    print("token:\(token)")
    guard let exams = await ioStud.retrieveExamsGrades() else {
        print("Errore esami")
        return
    }

    for exam in exams {
        print(exam)
        print("----- ----- -----")
    }
    
    guard let bio = await ioStud.retrieveStudentBio() else {
        print("Errore bio")
        return
    }
    
    print(bio)
}

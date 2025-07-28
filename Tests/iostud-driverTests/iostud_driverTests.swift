import Testing
@testable import iostud_driver

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let ioStud = IoStud(studentID: matricola, studentPwd: password)
    await ioStud.doLogin()
    guard let token = try? ioStud.getSessionToken() else {
        return
    }
    print(token)
    guard let exams = await ioStud.retrieveExamsInfo() else {
        print("Errore esami")
        return
    }
    print(exams)
    /*for exam in exams {
        print(exam.descrizione)
        print(exam.cfu)
        print(exam.esito.valoreNominale)
        print("----- ----- -----")
    }*/
    
    guard let bio = await ioStud.retrieveStudentBio() else {
        print("Errore bio")
        return
    }
    
    print(bio)
}

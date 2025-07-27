import Testing
@testable import iostud_driver

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let matricola = ""
    let pwd = ""

    let ioStud = IoStud(studentID: matricola, studentPwd: pwd)
    await ioStud.doLogin()
    guard let token = try? ioStud.getSessionToken() else {
        return
    }
    print(token)
    let exams = await ioStud.retrieveExamsInfo()

    for exam in exams {
        print(exam.descrizione)
        print(exam.cfu)
        print(exam.esito.valoreNominale)
        print("----- ----- -----")
    }
}

# ioStudKit ![Static Badge](https://img.shields.io/badge/Swift-6.1+-orange?style=flat-square&logo=swift) ![Static Badge](https://img.shields.io/badge/macOS-12+-blue?style=flat-square) ![Static Badge](https://img.shields.io/badge/iOS-15+-blue?style=flat-square) [![Swift CI](https://github.com/IoStud/ioStudKit/actions/workflows/ci.yml/badge.svg)](https://github.com/IoStud/ioStudKit/actions/workflows/ci.yml)
**ioStudKit** is an **open-source** Swift Package that provides access to Sapienza University's InfoStud platform, enabling authentication, data retrieval, and exam reservations for your iOS/macOS apps.

## Functionalities

**Authentication**
- [x] Login
- [ ] Security question and password recovery
- [ ] Passsword reset

**Profile**
- [x] Student infos
- [ ] Certificates
- [ ] Photo and student card

**Classroom**
- [ ] Classroom and timetable

**Exams**
- [x] Doable and done exams
- [x] Active and available reservations
- [x] Insert and delete reservations
- [ ] Course surveys (OPIS)
- [ ] Pdf reservation
- [ ] Calendar events

**Taxes**
- [ ] Paid and unpaid taxes
- [ ] Current ISEE and ISEE history

**News**
- [ ] News and newsletter events

## How to install the package in your project

You can add **IoStudKit** to your Swift project either in Xcode or via the Swift Package Manager in Visual Studio Code. Steps may vary slightly depending on your IDE version.

### Xcode

1. In the menu bar, select **File > Add Packages…**  
2. Paste the repository URL: **https://github.com/IoStud/ioStudKit**  
3. Choose the version requirement and target project.  
4. Click **Add Package**.  
5. In your Swift files, import the module:

   ```swift
   import IoStudkit
   ```

### Other IDEs (Swift Package Manager)

1. Edit your **Package.swift** to include **IoStudKit** as a dependency:

   ```swift
   import PackageDescription

   let package = Package(
       name: "YourProject",
       dependencies: [
           .package(url: "https://github.com/IoStud/ioStudKit", from: "1.0.0")
       ],
       targets: [
           .target(
               name: "YourProject",
               dependencies: ["ioStudKit"]
           )
       ]
   )
   ```
3. Build your project:  
   ```bash
   swift build
   ```

## How to use it

All functionalities are accessible through a single **IoStud** instance by calling the corresponding methods. First, create your IoStud client with your **student ID** and **password**. The library handles login and token refresh automatically.

```swift
let ioStud = IoStud(studentID: "12345678", studentPwd: "yourPassword")
```

Below are common usage examples:

### Retrieve Student Profile

```swift
if let bio = try await ioStud.retrieveStudentBio() {
   print(bio.name, bio.institutionalEmail, bio.academicYearOfCourse)
} else {
   print("Error while fetching student bio")
}
```

### Fetch Completed Exams

```swift
if let doneExams = await ioStud.retrieveDoneExams() {
    for exam in doneExams {
        print("Course:", exam.courseName)
        print("Grade:", exam.grade)
        print("Date:", exam.date)
        print("-----")
    }
} else {
    print("Error while fetching completed exams")
}
```

## Disclaimer

This project is **not an official InfoStud client** and is not affiliated with Sapienza University or the InfoStud platform in any way. It was developed independently by the contributors and does not include any input or endorsement from the InfoStud team.

## Acknowledgements

A significant part of the **IoStudKit** code was done by **adapting** and taking **inspiration** from **OpenStudDriver**, an open-source Java library primarily built for Android applications, which allows access to Infostud.

- The [original OpenStudDriver](https://github.com/leosarra/openstud_driver) code was developed by [@leosarra](https://github.com/leosarra) and other contributors.
- The current, [up-to-date OpenStudDriver](https://github.com/matypist/openstud_driver) code is maintained by [@matypist](https://github.com/matypist).
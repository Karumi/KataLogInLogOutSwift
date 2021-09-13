import XCTest
import Nimble
import Combine
@testable import KataLogInLogOutSwift

class KataLogInLogOutTests: XCTestCase {

    private static let anyValidPassword = "admin"
    private static let anyInvalidPassword = "pass"
    private static let anyValidUsername = "admin"
    private static let anyInvalidUsername = "user"

    private let clock = ClockMock()
    private var kata: KataLogInLogOut!

    override func setUp() {
        super.setUp()
        self.kata = KataLogInLogOut(clock: clock)
    }

    func testReturnsInvalidUsernameErrorIfTheUsernameContainsTheFirstInvalidChar() throws {
        let result = kata.logIn(username: "ad,min", password: KataLogInLogOutTests.anyValidPassword)

        expect { try result.get() }.to(throwError(LogInError.invalidUsername))
    }

    func testReturnsInvalidUsernameErrorIfTheUsernameContainsTheSecondInvalidChar() throws {
        let result = kata.logIn(username: "ad.min", password: KataLogInLogOutTests.anyValidPassword)

        expect { try result.get() }.to(throwError(LogInError.invalidUsername))
    }

    func testReturnsInvalidUsernameErrorIfTheUsernameContainsTheThirdInvalidChar() throws {
        let result = kata.logIn(username: "ad;min", password: KataLogInLogOutTests.anyValidPassword)

        expect { try result.get() }.to(throwError(LogInError.invalidUsername))
    }

    func testReturnsInvalidCredentialsIfTheUsernameIsNotCorrect() throws {
        let result = kata.logIn(username: KataLogInLogOutTests.anyInvalidUsername,
                                password: KataLogInLogOutTests.anyValidPassword)

        expect { try result.get() }.to(throwError(LogInError.invalidCredentials))
    }

    func testReturnsInvalidCredentialsIfThePasswordIsNotCorrect() throws {
        let result = kata.logIn(username: KataLogInLogOutTests.anyValidUsername,
                                password: KataLogInLogOutTests.anyInvalidPassword)

        expect { try result.get() }.to(throwError(LogInError.invalidCredentials))
    }

    func testReturnsTheUsernameIfTheUserAndPasswordAreCorrect() throws {
        let result = try kata.logIn(username: KataLogInLogOutTests.anyValidUsername,
                                password: KataLogInLogOutTests.anyValidPassword).get()
        
        expect(result.first!).to(equal(KataLogInLogOutTests.anyValidUsername))
    }

    func testReturnsAnErrorIfTheSecondWhenTheLogOutIsPerformedIsOdd() {
        givenNowIs(Date(timeIntervalSince1970: 3))

        let result = kata.logOut()

        expect(result).to(beFalse())
    }

    func testReturnsSuccessIfTheSecondWhenTheLogOutIsPerformedIsEven() {
        givenNowIs(Date(timeIntervalSince1970: 2))

        let result = kata.logOut()

        expect(result).to(beTrue())
    }

    private func givenNowIs(_ date: Date) {
        clock.mockedNow = date
    }

}

class ClockMock: Clock {

    var mockedNow: Date = Date()

    override var now: Date {
        return mockedNow
    }
}

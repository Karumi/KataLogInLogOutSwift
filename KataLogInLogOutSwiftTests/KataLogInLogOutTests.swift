import XCTest
import Nimble
import BrightFutures
import Result
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

    func testReturnsInvalidUsernameErrorIfTheUsernameContainsTheFirstInvalidChar() {
        let result = kata.logIn(username: "ad,min", password: KataLogInLogOutTests.anyValidPassword)

        expect(result.error).toEventually(equal(LogInError.invalidUsername))
    }

    func testReturnsInvalidUsernameErrorIfTheUsernameContainsTheSecondInvalidChar() {
        let result = kata.logIn(username: "ad.min", password: KataLogInLogOutTests.anyValidPassword)

        expect(result.error).toEventually(equal(LogInError.invalidUsername))
    }

    func testReturnsInvalidUsernameErrorIfTheUsernameContainsTheThirdInvalidChar() {
        let result = kata.logIn(username: "ad;min", password: KataLogInLogOutTests.anyValidPassword)

        expect(result.error).toEventually(equal(LogInError.invalidUsername))
    }

    func testReturnsInvalidCredentialsIfTheUsernameIsNotCorrect() {
        let result = kata.logIn(username: KataLogInLogOutTests.anyInvalidUsername,
                                password: KataLogInLogOutTests.anyValidPassword)

        expect(result.error).toEventually(equal(LogInError.invalidCredentials))
    }

    func testReturnsInvalidCredentialsIfThePasswordIsNotCorrect() {
        let result = kata.logIn(username: KataLogInLogOutTests.anyValidUsername,
                                password: KataLogInLogOutTests.anyInvalidPassword)

        expect(result.error).toEventually(equal(LogInError.invalidCredentials))
    }

    func testReturnsTheUsernameIfTheUserAndPasswordAreCorrect() {
        let result = kata.logIn(username: KataLogInLogOutTests.anyValidUsername,
                                password: KataLogInLogOutTests.anyValidPassword)

        expect(result.value).toEventually(equal(KataLogInLogOutTests.anyValidUsername))
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

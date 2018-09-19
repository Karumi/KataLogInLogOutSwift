import Foundation
import BrightFutures

class KataLogInLogOut {

    private let clock: Clock

    init(clock: Clock) {
        self.clock = clock
    }

    func logIn(username: String, password: String) ->  Future<String, LogInError> {
        return Future { complete in
            DispatchQueue.global().async {
                if (self.containsInvalidChars(username)) {
                    complete(.failure(.invalidUsername))
                } else if (self.areValidCredentials(username, password)) {
                    complete(.success(username))
                } else {
                    complete(.failure(.invalidCredentials))
                }
            }
        }
    }

    func logOut() -> Bool {
        let nowInSeconds = Int(clock.now.timeIntervalSince1970)
        return nowInSeconds % 2 == 0
    }

    private func containsInvalidChars(_ username: String) -> Bool {
        return username.contains(",") || username.contains(".") || username.contains(";")
    }

    private func areValidCredentials(_ username: String,_ password: String) -> Bool {
        return username == "admin" && password == "admin"
    }
}


enum LogInError: Error, Equatable {
    case invalidUsername, invalidCredentials

    static func ==(lhs: LogInError, rhs: LogInError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUsername,   .invalidUsername),
             (.invalidCredentials, .invalidCredentials):
            return true
        default:
            return false
        }
    }
}


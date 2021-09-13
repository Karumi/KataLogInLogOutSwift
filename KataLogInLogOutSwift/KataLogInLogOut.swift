import Combine
import Foundation

class KataLogInLogOut {
    private let clock: Clock

    init(clock: Clock) {
        self.clock = clock
    }

    func logIn(username: String, password: String) -> AnyPublisher<String, LogInError> {
        return Future { complete in
            DispatchQueue.global().async {
                if self.containsInvalidChars(username) {
                    complete(.failure(.invalidUsername))
                } else if self.areValidCredentials(username, password) {
                    complete(.success(username))
                } else {
                    complete(.failure(.invalidCredentials))
                }
            }
        }.eraseToAnyPublisher()
    }

    func logOut() -> AnyPublisher<Void, LogOutError> {
        let nowInSeconds = Int(clock.now.timeIntervalSince1970)
        return nowInSeconds % 2 == 0
            ? Empty(completeImmediately: true).setFailureType(to: LogOutError.self).eraseToAnyPublisher()
            : Fail(outputType: Void.self, failure: LogOutError.invalidTime).eraseToAnyPublisher()
    }

    private func containsInvalidChars(_ username: String) -> Bool {
        return username.contains(",") || username.contains(".") || username.contains(";")
    }

    private func areValidCredentials(_ username: String, _ password: String) -> Bool {
        return username == "admin" && password == "admin"
    }
}

enum LogInError: Error, Equatable {
    case invalidUsername, invalidCredentials
}

enum LogOutError: Error {
    case invalidTime
}

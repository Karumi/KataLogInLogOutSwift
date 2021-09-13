import Combine
import Foundation

class Presenter {
    private var subscriptions = Set<AnyCancellable>()

    private let kata: KataLogInLogOut
    private let view: View

    init(kataLogInLogOut: KataLogInLogOut, view: View) {
        self.kata = kataLogInLogOut
        self.view = view
    }

    func didTapLogInButton(username: String, password: String) {
        kata.logIn(username: username, password: password)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.view.hideLogInForm()
                    self.view.showLogOutForm()
                case .failure(.invalidCredentials):
                    self.view.showError(message: "Invalid credentials")
                case .failure(.invalidUsername):
                    self.view.showError(message: "Invalid username")
                }
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }

    func didTapLogOutButton() {
        kata.logOut()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.view.hideLogOutForm()
                    self.view.showLogInForm()
                case .failure:
                    self.view.showError(message: "Log out error")
                }
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
}

protocol View {
    func showError(message: String)
    func showLogInForm()
    func hideLogInForm()
    func showLogOutForm()
    func hideLogOutForm()
}

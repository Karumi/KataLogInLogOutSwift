//
//  Presenter.swift
//  KataLogInLogOutSwift
//
//  Created by Pedro Vicente Gomez on 19/09/2018.
//  Copyright © 2018 GoKarumi. All rights reserved.
//

import Foundation

class Presenter {

    private let kata: KataLogInLogOut
    private let view: View

    init(kataLogInLogOut: KataLogInLogOut, view: View) {
        self.kata = kataLogInLogOut
        self.view = view
    }

    func didTapLogInButton(username: String, password: String) {
        kata.logIn(username: username, password: password)
            .onSuccess { _ in
                self.view.hideLogInForm()
                self.view.showLogOutForm()
            }.onFailure { error in
                switch error {
                case .invalidCredentials:
                    self.view.showError(message: "Invalid credentials")
                case .invalidUsername:
                    self.view.showError(message: "Invalid username")
                }
        }
    }

    func didTapLogOutButton() {
        if (kata.logOut()) {
            view.hideLogOutForm()
            view.showLogInForm()
        } else {
            view.showError(message: "Log out error")
        }
    }

}

protocol View {
    func showError(message: String)
    func showLogInForm()
    func hideLogInForm()
    func showLogOutForm()
    func hideLogOutForm()
}

import UIKit

class ViewController: UIViewController, View {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    private var presenter: Presenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Presenter(kataLogInLogOut: KataLogInLogOut(clock: Clock()), view: self)
    }

    @IBAction func onLogInButtonTap(_ sender: Any) {
        let user = username.text ?? ""
        let pass = password.text ?? ""
        presenter.didTapLogInButton(username: user, password: pass)
    }

    @IBAction func onLogOutButtonTap(_ sender: Any) {
        presenter.didTapLogOutButton()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showLogInForm() {
        logInButton.isHidden = false
        username.isHidden = false
        password.isHidden = false
    }

    func hideLogInForm() {
        logInButton.isHidden = true
        username.text = nil
        password.text = nil
        username.isHidden = true
        password.isHidden = true
    }

    func showLogOutForm() {
        logOutButton.isHidden = false
    }

    func hideLogOutForm() {
        logOutButton.isHidden = true
    }
}

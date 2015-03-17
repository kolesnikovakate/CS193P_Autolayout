//
//  ViewController.swift
//  Autolayout
//
//  Created by Екатерина Колесникова on 17.03.15.
//  Copyright (c) 2015 kkate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    var loggedInUser: User? { didSet { updateUI() } }

    var secure: Bool = false { didSet { updateUI() } }

    private func updateUI() {
        passwordField?.secureTextEntry = secure
        passwordLabel?.text = secure ? "Secured Password" : "Password"
        nameLabel?.text = loggedInUser?.name
        companyLabel?.text = loggedInUser?.company
        image = loggedInUser?.image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction private func login() {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
    }

    @IBAction private func toggleSecurity() {
        secure = !secure
    }

    private var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue {
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }

    private var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let existingConstraint = aspectRatioConstraint {
                view.removeConstraint(existingConstraint)
            }
        }
        didSet {
            if let newConstraint = aspectRatioConstraint {
                view.addConstraint(newConstraint)
            }
        }
    }
}

private extension User
{
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        } else {
            return UIImage(named: "unknown_user")
        }
    }
}

extension UIImage
{
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}


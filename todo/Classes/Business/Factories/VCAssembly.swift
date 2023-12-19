//
//  VCAssembly.swift
//  todo
//
//  Created by admin on 14.12.2023.
//

import Dip
import UIKit

enum VCAssembly {
    // swiftlint:disable:next closure_body_length
    static let container: DependencyContainer = {
        let container = DependencyContainer()
        container.collaborate(with: ManagersAssembly.container)
        container.register { AuthViewController() }
        container.register { SignUpViewController() }
        container.register { MainViewController() }
        container.register { NewItemViewController() }
        container.register { ProfileViewController() }
        return container
    }()
}

extension AuthViewController: StoryboardInstantiatable {}

extension SignUpViewController: StoryboardInstantiatable {}

extension MainViewController: StoryboardInstantiatable {}

extension NewItemViewController: StoryboardInstantiatable {}

extension ProfileViewController: StoryboardInstantiatable {}

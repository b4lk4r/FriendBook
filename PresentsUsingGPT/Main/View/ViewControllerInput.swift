//
//  ViewControllerInput.swift
//  PresentsUsingGPT
//
//  Created by Stas Iarikov on 02.06.2025.
//

import Foundation

protocol ViewControllerInput: AnyObject {
    func showResponse(_ response: String)
    func showError(_ error: String)
}

//
//  Alertinator.swift
//  PartyUI
//
//  Created by lunginspector on 2/12/26.
//

import Foundation
import UIKit

@MainActor
public class Alertinator {
    public static let shared = Alertinator()
    
    var alertController: UIAlertController?
    
    public func alert(title: String, body: String, showCancel: Bool = true) {
        Task { @MainActor in
            alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
            if showCancel {
                alertController?.addAction(.init(title: "OK", style: .cancel))
            }
            alertController?.view.tintColor = UIColor(named: "AccentColor")
            self.present(alertController!)
        }
    }
    
    public func alert(title: String, body: String, showCancel: Bool = true, actionLabel: String = "OK", action: @escaping () -> Void) {
        Task { @MainActor in
            alertController = UIAlertController(title: title, message: body, preferredStyle: .alert)
            alertController?.addAction(.init(title: actionLabel, style: .default) { _ in
                action()
            })
            if showCancel {
                alertController?.addAction(.init(title: "Cancel", style: .cancel))
            }
            alertController?.view.tintColor = UIColor(named: "AccentColor")
            self.present(alertController!)
        }
    }
    
    public func prompt(title: String, placeholder: String = "", text: String = "", showCancel: Bool = true, completion: @escaping (String?) async -> Void) {
        Task { @MainActor in
            alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alertController?.addTextField { field in
                if !placeholder.isEmpty {
                    field.placeholder = placeholder
                }
                if !text.isEmpty {
                    field.text = text
                }
            }
            if showCancel {
                alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    Task {
                        await completion(nil)
                    }
                })
            }
            alertController?.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                let field = self.alertController?.textFields?.first
                Task {
                    await completion(field?.text)
                }
            })
            alertController?.view.tintColor = UIColor(named: "AccentColor")
            self.present(alertController!)
        }
    }
    
    /// Shows a sequence of warning alerts, one at a time. Each alert's
    /// "Continue" button dismisses it and presents the next; the last alert's
    /// confirm button runs `onConfirm`. Used before a respring that could
    /// leave the device unusable.
    @MainActor
    public func warningChain(title: String, messages: [String], confirmLabel: String, onConfirm: @escaping () -> Void) {
        guard !messages.isEmpty else {
            onConfirm()
            return
        }

        func showStep(_ index: Int) {
            guard index < messages.count else {
                onConfirm()
                return
            }
            let isLast = index == messages.count - 1
            let alert = UIAlertController(title: title, message: messages[index], preferredStyle: .alert)
            alert.addAction(.init(title: isLast ? confirmLabel : "Continue", style: .destructive) { _ in
                alert.dismiss(animated: true) {
                    // Let UIKit finish the dismissal before presenting the next
                    // one, otherwise the new alert can be dropped.
                    DispatchQueue.main.async {
                        showStep(index + 1)
                    }
                }
            })
            alert.addAction(.init(title: "Cancel", style: .cancel))
            alert.view.tintColor = UIColor(named: "AccentColor")
            self.alertController = alert
            present(alert)
        }

        showStep(0)
    }

    @MainActor
    private func present(_ alert: UIAlertController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           var topController = window.rootViewController {
            
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alert, animated: true)
        }
    }
}

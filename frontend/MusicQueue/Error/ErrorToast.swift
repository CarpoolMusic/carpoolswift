//
//  ErrorToast.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-01-21.
//

class ErrorToast {
    static let shared = ErrorToast()
    
    private init() {}

    func showToast(message: String) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let toastLabel = UILabel()
        // Configure your toastLabel - set the text, color, position, etc.
        toastLabel.text = message
        
        window.addSubview(toastLabel)
        // Add animation or time delay as needed
        UIView.animate(withDuration: 3.0, animations: {
            toastLabel.alpha = 0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

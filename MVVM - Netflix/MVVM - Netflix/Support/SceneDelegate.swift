//
//  SceneDelegate.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 14.10.2025.
//

import UIKit
// SceneDelegate, uygulamanın kullanıcı arayüzü (UI) katmanının yaşam döngüsünü yönetir.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // Bu, uygulamamızın içeriğini gösterecek olan pencereyi tutan bir özelliktir. Tüm UIViewController'lar bu pencere üzerinde gösterilir.
    var window: UIWindow?

    // Bu fonksiyon, uygulamanın bir sahnesinin (penceresinin) oluşturulduğu ve ekranda gösterilmeye hazırlandığı anda sistem tarafından çağrılır. Başlangıç noktası burasıdır.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // yeni bir UIWindow oluşturuyoruz. Bu pencere, uygulamamızın tüm arayüzünü taşıyacak olan ana çerçevedir.
        window = UIWindow(windowScene: windowScene)
        
        let onboardingVC = OnboardingViewController()
        onboardingVC.delegate = self
        
        // Uygulama açıldığında kullanıcıya ilk gösterilecek ekranı burada belirliyoruz.
        window?.rootViewController = onboardingVC
        
        // Ekranı görünür hale getiririz
        window?.makeKeyAndVisible()
        
    }
    
    
    func changeRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        window.rootViewController = viewController
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        }
    }

}

extension SceneDelegate : OnboardingViewControllerDelegate {
    func didFinishOnboarding() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        
        // Login ve Register arası geçiş için bir Navigation Controller'a ihtiyacımız var.
        let navigationController = UINavigationController(rootViewController: loginVC)
        changeRootViewController(to: navigationController)
    }
    
    
}

// SceneDelegate'in LoginViewControllerDelegate protokolünü uyguladığını belirtiyoruz
extension SceneDelegate: LoginViewControllerDelegate {
    func didFinishLogin() {
        // Login işlemi bittiğinde ana ekrana geç.
        // Senin yazdığın yardımcı fonksiyonu burada çağırıyoruz!
        print("Delegate çalıştı: Ana ekrana geçiliyor...")
        changeRootViewController(to: MainTabbarController())
    }
    
    func didTapRegister() {
        // Mevcut root bir navigation controller olduğu için, ona yeni bir VC "push" edebiliriz.
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        navigationController.pushViewController(registerVC, animated: true)
    }
}

extension SceneDelegate: RegisterViewControllerDelegate {
    func didFinishRegister() {
        // Register işlemi bitince ana ekrana geç
        print("Delegate çalıştı: Ana ekrana geçiliyor...")
        changeRootViewController(to: MainTabbarController())
    }
}

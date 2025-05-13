import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Uygulama başlatıldığında yapılacak işlemler
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Uygulama başlatıldığında yapılacak işlemler
        // Örnek: global stil ayarları
        UINavigationBar.appearance().barTintColor = UIColor.systemBlue
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        return true
    }

    // Uygulama arka planda iken aktif olur
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Uygulama arka planda iken yapılacak işlemler
        print("Uygulama arka plana geçti")
    }

    // Uygulama arka plandaki işlemi tekrar ön planda başlatır
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Uygulama ön planda başlatıldığında yapılacak işlemler
        print("Uygulama ön planda")
    }

    // Uygulama kapanmadan önce yapılacak işlemler
    func applicationWillTerminate(_ application: UIApplication) {
        // Uygulama kapanmadan önce yapılacak işlemler
        print("Uygulama kapanıyor")
    }
    
    // Uygulama, bildirimler aldığında çağrılır
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any]) {
        // Uygulama bildirim aldığında yapılacak işlemler
        print("Push bildirimi alındı")
    }
}

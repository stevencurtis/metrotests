




[Images/AddGoogleService.png](Images/AddGoogleService.png]<br>

[Images/addpackage.png](Images/addpackage.png]<br>

[Images/addpackage2.png](Images/addpackage2.png]<br>


[Images/firebaseanalytics.png](Images/firebaseanalytics.png]<br>


Add Swift Package
https://github.com/firebase/firebase-ios-sdk



```swift
import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
```

Link Binary With Libraries

[Images/linkbinary.png](Images/linkbinary.png]<br>


# Basic version

```swift
import FirebaseAnalytics
import FirebaseCore
import UIKit
import FirebaseRemoteConfigInternal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        fetchFeatureFlags()
        return true
    }
    
    func fetchFeatureFlags() {
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0  // During testing
        // settings.isDeveloperModeEnabled = true  // Depreciated but useful for immediate effects
        config.configSettings = settings
        // Configure minimum fetch interval
        config.fetchAndActivate { status, error in
            if let error = error {
                print("Error during Remote Config fetch: \(error.localizedDescription)")
            } else {
                print("Remote Config fetched and activated \(status)")
                
                let testValue = RemoteConfig.remoteConfig().configValue(forKey: "test").boolValue
                     print("Test Value: \(String(describing: testValue))")
            }
        }
    }
```

This can be accessed within the View Controller.
Something like this will do:

```swift
import FirebaseRemoteConfigInternal
import UIKit

final class ViewController: UIViewController {

    @IBOutlet private var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let testValue = RemoteConfig.remoteConfig().configValue(forKey: "test").boolValue
        if testValue {
            testLabel.text = "value true"
        } else {
            testLabel.text = "value false"
        }
        print("Test Values: \(String(describing: testValue))")
    }
}
```

Which isn't great. Each time we want to use a flag we need to import FirebaseRemoteConfigInternal, and we need to know the configvalue. And there is boilerplate code. It all isn't great.

# Moving to the View Model
Using storyboards is a bit of a pain for this, but we will persist. Let's use a closure for updating the view controller too to try to make this simple.

ViewController:
```swift
import UIKit

final class ViewController: UIViewController {
    var viewModel = ViewModel()

    @IBOutlet private var testLabel: UILabel!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateHandler = { [weak self] testValue in
            DispatchQueue.main.async {
                self?.testLabel.text = testValue ? "value true" : "value false"
            }
        }
        
        viewModel.fetchFeatureFlag()
    }
}

```

ViewModel:

```swift
import Foundation
import FirebaseRemoteConfigInternal

final class ViewModel {
    var updateHandler: ((Bool) -> Void)?
    var testValue: Bool = false {
        didSet {
            updateHandler?(testValue)
        }
    }
    
    func fetchFeatureFlag() {
        let config = RemoteConfig.remoteConfig()
        config.fetchAndActivate { [weak self] status, error in
            if let error = error {
                print("Error fetching config: \(error.localizedDescription)")
            } else {
                print("Config fetched and activated")
                self?.testValue = config.configValue(forKey: "test").boolValue
            }
        }
    }
}
```

But...there is still too much boilerplate code,

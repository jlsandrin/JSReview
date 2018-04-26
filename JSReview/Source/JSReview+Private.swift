import Foundation

internal extension JSReview {
    /// Identifies if user's first use.
    /// If first use and date hasn't been set yet, sets a new date to now
    var isFirstUse: Bool {
        get {
            return userDefaults.bool(forKey: identifierFirstUse)
        }
        
        set {
            userDefaults.set(newValue, forKey: identifierFirstUse)
            guard let _ = userDefaults.value(forKey: identifierLastRemidedDate) as? Date else {
                setReview(Date())
                return
            }
        }
    }
    
    /// If user reviewed or selected to not be reminded, this will be set to true.
    /// If this is true, user does not want to be bothered anymore.
    var reviewed: Bool {
        get {
            return userDefaults.bool(forKey: identifierReviewed)
        }
        
        set {
            userDefaults.set(newValue, forKey: identifierReviewed)
        }
    }
    
    var reviewDate: Date? {
        get {
            return userDefaults.value(forKey: identifierLastRemidedDate) as? Date
        }
        
        set {
            userDefaults.set(newValue, forKey: identifierLastRemidedDate)
        }
    }
    
    /// Identifies if should present an alert controller for user to review app
    func shouldAskToReview() -> Bool {
        if isDevelopmentMode {
            return true
        }
        
        if reviewed {
            return false
        }
        
        if let lastReviewDate = reviewDate,
            let daysToFirstRequest = daysUntilRequest,
            let daysToRemember = daysUntilRemember {
            let timeInterval = lastReviewDate.timeIntervalSinceNow
            return -timeInterval > (self.isFirstUse ? Double(daysToFirstRequest * secondsInADay) : Double(daysToRemember * secondsInADay))
        }
        return true
    }
    
    /// Creates an instance of AlertController with default actions
    func alertToReview() -> UIAlertController {
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let reviewAction = UIAlertAction(title: reviewActionTitle,
                                         style: .default) { [weak self] (action) in
                                            self?.review(self?.appID)
        }
        
        let rememberAction = UIAlertAction(title: rememberLaterActionTitle,
                                           style: .default) { [weak self] (action) in
                                            self?.rememberLater()
        }
        
        let doNotRememberAction = UIAlertAction(title: forgetActionTitle,
                                                style: .destructive) { [weak self] (action) in
                                                    self?.doNotRemember()
        }
        
        alertController.addAction(reviewAction)
        alertController.addAction(rememberAction)
        alertController.addAction(doNotRememberAction)
        alertController.preferredAction = reviewAction
        return alertController
    }
    
    /// Finds library Bundle and returns a localized message for key
    /// - parameter key: Key to look for localized message
    func localizedString(_ key: String) -> String {
        let language = locale?.languageCode ?? Locale.current.languageCode
        if let bundlePath = Bundle(for: JSReview.self).path(forResource: "Localization", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath),
            let folderPath = bundle.path(forResource: language, ofType: "lproj"),
            let localizedBundle = Bundle(path: folderPath) {
            return localizedBundle.localizedString(forKey: key,
                                                   value: "",
                                                   table: nil)
        }
        return ""
    }
    
    /// User selected to review app
    /// - parameter appID: Your app's ID
    func review(_ appID: String?) {
        guard let appID = appID else {
            fatalError("Please set your app's ID before reviewing app")
        }
        
        let strURL = String(format: itunesStoreURL, appID)
        if let url = URL(string: strURL) {
            urlOpener.open(url)
        }
        doNotRemember()
    }

    /// User selected to be remembered on a later date
    func rememberLater() {
        reviewed = false
        isFirstUse = false
        setReview(Date())
    }
    
    /// User selected to not be remembered anymore
    func doNotRemember() {
        reviewed = true
        setReview(Date())
    }
    
    /// Sets last review date
    func setReview(_ date: Date) {
        reviewDate = date
    }
}

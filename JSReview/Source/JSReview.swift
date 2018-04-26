import Foundation

public protocol JSReviewInterface: class {
    var alertTitle: String? { get set }
    var alertMessage: String? { get set }
    var reviewActionTitle: String? { get set }
    var rememberLaterActionTitle: String? { get set }
    var forgetActionTitle: String? { get set }
    var appID: String { get set }
    var isDevelopmentMode: Bool { get set }
    var daysUntilRequest: Int? { get set }
    var daysUntilRemember: Int? { get set }
    func askToReview(on view: UIViewController, completion: ((_ success: Bool) -> Void)?)
    init(appID: String)
}

/**
 * Review class which conforms to ReviewInterface. Responsible for
 * managing and requesting user's review.
 */
public class JSReview: JSReviewInterface {
    // Properties identifiers
    internal let identifierFirstUse: String = "reviewIsFirstUse"
    internal let identifierDaysToRequest: String = "reviewDaystoRequest"
    internal let identifierDaysToRemember: String = "reviewDaysToRemeber"
    internal let identifierLastRemidedDate: String = "reviewLastRemindedDate"
    internal let identifierReviewed: String = "reviewAlreadyReviewed"
    internal let alertTitleIdentifier: String = "alert.title"
    internal let alertMessageIdentifier: String = "alert.message"
    internal let alertReviewTitleIdentifier: String = "review.title"
    internal let rememberLaterIdentifier: String = "remember-later.title"
    internal let neverRememberIdentifier: String = "do-not-remember.title"
    internal let appIDIdentifier: String = "appID.identifier"
    internal let isDevelopmentIdentifier: String = "isDevelopment.identifier"
    internal let localeIdentifier: String = "locale.identifier"
    
    // Itunes Store URL
    internal let itunesStoreURL: String = "itms-apps:itunes.apple.com/app/%@?mt=8&action=write-review"
    internal let secondsInADay = 60 * 60 * 24
    
    /// UIApplication used for opening review screen
    internal var urlOpener: URLOpenerInterface
    
    /// USerDefaults used for storing values
    internal let userDefaults: UserDefaults
    
    /**
     Initializes new JSReview with given app ID and in production mode.
     All other values are nil
     - parameter appID: JSReview will use this value to redirect user to your app's page on AppStore
     */
    public required convenience init(appID: String) {
        self.init(appID: appID,
                  daysUntilRequest: 15,
                  daysUntilRemember: 15,
                  locale: .current)
    }
    
    /**
     Initializes a new JSReview with given values.
     - Parameters:
        - appID: JSReview will use this value to redirect user to your app's page on AppStore
        - developmentMode: If set to true Review popup will always appear
        - alertTitle: Alert title that will appear with popup
        - message: Message asking user to review your app.
        - reviewActionTitle: Review button title
        - rememberActionTitle: Rememver-me later button title
        - forgetActionTitle: Never ask again button title
        - daysUntilRequest: Amount of days until app asks user to review for thr first time. Default is 15
        - daysUntilRemember: Days until app will ask again after user selected "Remember me later" option. Default is 15
        - locale: Used to determine localization messagens when presenting alert controller. Defaul is current.
     - warning: Strings should already be localized.
    */
    public init(appID: String,
                developmentMode: Bool = false,
                alertTitle: String? = nil,
                message: String? = nil,
                reviewActionTitle: String? = nil,
                rememberActionTitle: String? = nil,
                forgetActionTitle: String? = nil,
                daysUntilRequest: Int = 15,
                daysUntilRemember: Int = 15,
                locale: Locale = .current,
                urlOpener: URLOpenerInterface = URLOpener(),
                userDefaults: UserDefaults = .standard) {
        self.urlOpener = urlOpener
        self.userDefaults = userDefaults
        self.appID = appID
        self.isDevelopmentMode = developmentMode
        self.alertTitle = alertTitle
        self.alertMessage = message
        self.reviewActionTitle = reviewActionTitle
        self.rememberLaterActionTitle = rememberActionTitle
        self.forgetActionTitle = forgetActionTitle
        self.daysUntilRequest = daysUntilRequest
        self.daysUntilRemember = daysUntilRemember
        self.locale = locale
        if userDefaults.value(forKey: identifierLastRemidedDate) as? Date == nil {
            isFirstUse = true
        }
    }
    
    /// Title to show when asking user to review
    /// - warning: This will not be localized
    public var alertTitle: String? {
        get {
            return userDefaults.string(forKey: alertTitleIdentifier) ?? localizedString(alertTitleIdentifier)
        }
        
        set {
            userDefaults.set(newValue, forKey: alertTitleIdentifier)
        }
    }
    
    /// Message to show user when asking to review
    /// - warning: This will not be localized
    public var alertMessage: String? {
        get {
            return userDefaults.string(forKey: alertMessageIdentifier) ?? localizedString(alertMessageIdentifier)
        }
        
        set {
            userDefaults.set(newValue, forKey: alertMessageIdentifier)
        }
    }
    
    /// Review button title
    /// - warning: This will not be localized
    public var reviewActionTitle: String? {
        get {
            return userDefaults.string(forKey: alertReviewTitleIdentifier) ?? localizedString(alertReviewTitleIdentifier)
        }
        
        set {
            userDefaults.set(newValue, forKey: alertReviewTitleIdentifier)
        }
    }
    
    /// Remember-me later button title
    /// - warning: This will not be localized
    public var rememberLaterActionTitle: String? {
        get {
            return userDefaults.string(forKey: rememberLaterIdentifier) ?? localizedString(rememberLaterIdentifier)
        }
        
        set {
            userDefaults.set(newValue, forKey: rememberLaterIdentifier)
        }
    }
    
    /// Don't remember me button title
    /// - warning: This will not be localized
    public var forgetActionTitle: String? {
        get {
            return userDefaults.string(forKey: neverRememberIdentifier) ?? localizedString(neverRememberIdentifier)
        }
        
        set {
            userDefaults.set(newValue, forKey: neverRememberIdentifier)
        }
    }
    
    /// Your app's ID to link alert to AppStore review page
    /// - warning: App ID needs to be in this format: **id[AppID]**
    public var appID: String {
        get {
            guard let appID = userDefaults.string(forKey: appIDIdentifier) else {
                fatalError("APP ID cannot be nil")
            }
            return appID
        }
        
        set {
            userDefaults.setValue(newValue, forKey: appIDIdentifier)
        }
    }
    
    /// Default is false. If set to true, will always present alert controller with Review
    /// - warning: Don't forget to turn it to false when shipping your app.
    public var isDevelopmentMode: Bool {
        get {
            return userDefaults.bool(forKey: isDevelopmentIdentifier)
        }
        
        set {
            userDefaults.set(newValue, forKey: isDevelopmentIdentifier)
        }
    }

    /// Days until you can request user to review the app. Default is 15 days.
    public var daysUntilRequest: Int? {
        get {
            return userDefaults.integer(forKey: identifierDaysToRequest)
        }
        
        set {
            userDefaults.set(newValue, forKey: identifierDaysToRequest)
        }
    }
    
    /// If user selects *Remember-me Later* option, how many days until you can request again.
    /// Default is 15.
    public var daysUntilRemember: Int? {
        get {
            return userDefaults.integer(forKey: identifierDaysToRemember)
        }
        
        set {
            userDefaults.set(newValue, forKey: identifierDaysToRemember)
        }
    }
    
    /// Locale to be used when getting localized messages
    public var locale: Locale? {
        get {
            if let identifier = userDefaults.string(forKey: localeIdentifier) {
                return Locale(identifier: identifier)
            }
            return nil
        }
        
        set {
            userDefaults.set(newValue?.identifier, forKey: localeIdentifier)
        }
    }
    
    /**
     * Checks if can show review alert to user. If all the requirements are met, presents an alert
     * with custom messages, and if they are not found, with default ones.
     */
    public func askToReview(on view: UIViewController, completion: ((_ success: Bool) -> Void)?) {
        if !shouldAskToReview() {
            completion?(false)
            return
        }
        let alert = alertToReview()
        view.present(alert,
                     animated: true) {
                        completion?(true)
        }
    }
}

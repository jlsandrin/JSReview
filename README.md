# Purpose
--------------

JSReview is a library to help you ask for user feedback on the App Store, after user has been using app for a few days. Currently supporting asking for feedback based on days from first use, we plan on updating it to have more options.

# Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 10.0

Installation
--------------

## Cocoapods
--------------
Simply add pod 
```
'JSReview', :git => 'https://github.com/jlsandrin/JSReview.git', :tag => '1.0.1'
```

to your Podfile and run `pod install`.



Configuration
--------------

Any value used to instantiate a new version of JSReview is stored in USerDefaults and can be replaced if a new object is creatded created with different values.

To instantiate a new object you can use a common init

```
init(appID: String)
```
that starts a new object with default values for days to request user feedback, and default values for localization. Or you can use a more complete init, which you can set every value currently used by JSReview.

```
init(appID: String,
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
                userDefaults: UserDefaults = .standard)
```

Each of the values above are used, somehow, by JSReview, so let's get into detail.

```
let appID: String
```

This is required to use JSReview, it's your app's ID on the AppStore. It needs to be in the format of **id[APPID]**, A.K.A., only the numbers of your app.

```
var developmentMode: Bool
```

Whenever this value is set to true, JSReview will alwayas present a new alert asking for user feedback.

```
var alerTitle: String?
```

Message to be used on alert that is going to be presented to the user of the app. This needs to be already localized.

```
var message: String
```

A message asking user to review your app.

```
var reviewActionTitle: String?
```

This will be used as the review button title.

```
var rememberActionTitle: String?
```

This will be used as the Remember-me Later button title.

```
var forgetActionTitle: String?
```

This will be used as the Don't Remember me Later button title.

```
var daysUntilRequest: Int
```

How many days need to pass before JSReview user to review the app for the first time.

```
var daysUntilRemember: Int
```

How many days until JSReviews asks user to review app again, after he/she selected "Remember-me Later" option.

```
var locale: Locale
```

For testing purposes, if you need to check if JSReview is selecting correct messages for different localizations.

```
var urlOpener: URLOpenerInterface
```

Wrapper to check and open URLs in the app. URLOpenerInterface is a protocol to make easier tests.

```
var userDefaults: UserDefaults
```

We use UserDefaults to save JSReview configuration.
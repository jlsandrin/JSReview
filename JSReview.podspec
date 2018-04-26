Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "JSReview"
  s.version      = "1.0.1"
  s.summary      = "JSReview is simple solution for asking users to review your app."

  # This description is used to generate tags and improve search results.

  s.description  = <<-DESC
                  JSReview provides an easy way to let your users review your app. You can set the amount of days until the first request as well as the subsequent requests after user selects "Remember me Later".
                   DESC

  s.homepage     = "https://github.com/jlsandrin/JSReview"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "Jean Sandrin" => "jl.sandrin@gmail.com" }
  s.social_media_url   = "http://twitter.com/jean_sandrin"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios
  s.platform     = :ios, "10.0"
  s.swift_version = "4.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/jlsandrin/JSReview.git", :tag => "#{s.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "JSReview", "JSReview/**/*.{h,m,swift}"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.resource  = "JSReview/Supporting Files/Localization.bundle"

end

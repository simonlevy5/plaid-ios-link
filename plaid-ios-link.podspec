Pod::Spec.new do |s|
  s.name             = "plaid-ios-link"
  s.version          = "0.1.0"
  s.summary          = "Native iOS implementation of Plaid Link"

  s.homepage         = "https://github.com/vouch/plaid-ios-link"
  s.license          = 'MIT'
  s.author           = { "Simon Levy" => "simon@vouch.com", "Andres Ugarte" => "andres@vouch.com" }
  s.source           = { :git => "https://github.com/vouch/plaid-ios-link.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'PlaidLink/Classes/**/*'
  s.public_header_files = 'PlaidLink/Classes/*.h'
  s.dependency 'plaid-ios-sdk'
end

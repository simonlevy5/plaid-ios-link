[![Build Status](https://travis-ci.org/vouch/plaid-ios-link.svg)](https://travis-ci.org/vouch/plaid-ios-link)
[![Platforms](https://img.shields.io/badge/platform-ios-lightgrey.svg)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/vouch/plaid-ios-link/blob/master/LICENSE)

# plaid-ios-link
Plaid Link experience built natively for iOS. For more on Plaid Link, please see https://github.com/plaid/link

This project is currently under active development.

**Demo**

[![Demo](https://media.giphy.com/media/VS4Jm37UWT6Eg/giphy.gif)](https://www.youtube.com/watch?v=Brnwkmj4v60)

https://www.youtube.com/watch?v=Brnwkmj4v60


**Usage**

For development:
The plaid-ios-sdk (https://github.com/vouch/plaid-ios-sdk) is required to use this. There are two options:

1. Use the Cocoapods and run the following command:
    pod install
2. Download the plaid-ios-sdk project and add the following to your Podfile:
    pod 'plaid-ios-sdk', :path => 'path_to_project'

The second option allows for developing against the local version of the SDK if changes are required.

**Project Tasks**

1. Documentation & Usage
2. Address known issues

**Known issues**
- Not showing account recovery or locked out links

**License**

plaid-ios-link is released under the MIT license. See [LICENSE](https://github.com/vouch/plaid-ios-link/blob/master/LICENSE) for details.

# plaid-ios-link
Plaid Link experience built natively for iOS. For more on Plaid Link, please see https://github.com/plaid/link

**Usage**

For development:
Right now the Plaid library is required to run this. Edit Podfile and enter the path to that library (https://github.com/vouch/plaid-ios-sdk) for the plaid-ios-sdk Pod. Then open the workspace and run the PlaidLink target.

**Project Tasks**

1. Documentation & Usage
2. Move test targets to subproject
3. Address known issues

**Known issues**
- Copy in login inputs aren't desirable (Using hardcoded strings vs. institution-specific values)
- Error messages are being pulled from API
- Not showing forgot password, account recovery, or locked out links
- Need better loading states for very long loading situations

**License**

plaid-ios-link is released under the MIT license. See [LICENSE](https://github.com/vouch/plaid-ios-link/blob/master/LICENSE) for details.

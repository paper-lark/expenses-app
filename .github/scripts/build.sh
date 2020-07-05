#!/bin/sh

set -eo pipefail
xcodebuild -project 'expenses.xcodeproj' \
            -destination platform='iOS Simulator,OS=13.2,name=iPhone 11' \
            clean build \
	    CODE_SIGN_IDENTITY='' CODE_SIGNING_REQUIRED='NO' \
	    CODE_SIGN_ENTITLEMENTS='' CODE_SIGNING_ALLOWED='NO'

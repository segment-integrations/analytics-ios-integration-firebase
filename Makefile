SDK ?= "iphonesimulator"
DESTINATION ?= "platform=iOS Simulator,name=iPhone 5"
PROJECT := Segment-Firebase
XC_ARGS := -scheme $(PROJECT)-Example -workspace Example/$(PROJECT).xcworkspace -sdk $(SDK) -destination $(DESTINATION) ONLY_ACTIVE_ARCH=NO

install: Example/Podfile $(PROJECT).podspec
	pod repo update
	pod install --project-directory=Example

lint:
	pod lib lint --use-libraries

clean:
	set -o pipefail && xcodebuild $(XC_ARGS) clean | xcpretty

build:
	set -o pipefail && xcodebuild $(XC_ARGS) | xcpretty

test:
	set -o pipefail && xcodebuild test $(XC_ARGS) | xcpretty --report junit

.PHONY: clean install build test

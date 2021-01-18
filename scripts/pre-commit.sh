#!/bin/sh
echo "Running pre-commit hook"
if which swiftlint >/dev/null; then
    swiftlint
    if [ $? -ne 0 ]; then
        echo "Lint must pass before commit!"
        exit 1
    fi
else
  echo "Error: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
  exit 1
fi

swift test --enable-code-coverage
if [ $? -ne 0 ]; then
    echo "Tests must pass before commit!"
    exit 1
fi

echo "Updating test definitions for Linux"
swift test --generate-linuxmain
git add Tests/MonkeyTests/XCTestManifests.swift
git add Tests/RosettaTests/XCTestManifests.swift
git add Tests/LinuxMain.swift

echo "Generating documentation"
sourcedocs generate --all-modules
git add Documentation/

echo "All good!"

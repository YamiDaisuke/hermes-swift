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

cd Rosetta/
swift test
cd ../
if [ $? -ne 0 ]; then
    echo "Tests must pass before commit!"
    exit 1
fi

cd languages/Monkey
swift test
cd ../../
if [ $? -ne 0 ]; then
    echo "Tests must pass before commit!"
    exit 1
fi

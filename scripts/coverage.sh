#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OS="Linux";;
    Darwin*)    OS="Mac";;
    *)          OS="UNKNOWN:${unameOut}"
esac

echo "Running on ${OS}"

FRAMEWORK_NAME=Hermes

if [ "$OS" == "Linux" ]
then
    # Saves  report for codecov
    llvm-cov export -format="lcov" \
        .build/debug/${FRAMEWORK_NAME}PackageTests.xctest \
        -instr-profile .build/debug/codecov/default.profdata > info.lcov
fi

if [ "$OS" == "Mac" ]; then
    # Saves  report for codecov
    xcrun llvm-cov export -format="lcov" \
        .build/debug/${FRAMEWORK_NAME}PackageTests.xctest/Contents/MacOS/${FRAMEWORK_NAME}PackageTests \
        -instr-profile .build/debug/codecov/default.profdata > info.lcov
    # Prints report to the terminal in a human readable format
    xcrun llvm-cov report \
        .build/debug/${FRAMEWORK_NAME}PackageTests.xctest/Contents/MacOS/${FRAMEWORK_NAME}PackageTests \
        -instr-profile .build/debug/codecov/default.profdata
fi

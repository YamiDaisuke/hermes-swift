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
    llvm-cov export -format="lcov" \
        .build/debug/${FRAMEWORK_NAME}PackageTests.xctest \
        -instr-profile .build/debug/codecov/default.profdata > info.lcov
fi

if [ "$OS" == "Mac" ]; then
    xcrun llvm-cov export -format="lcov" .build/debug/${FRAMEWORK_NAME}PackageTests.xctest/Contents/MacOS/${FRAMEWORK_NAME}PackageTests -instr-profile .build/debug/codecov/default.profdata > info.lcov
fi

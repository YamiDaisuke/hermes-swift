FRAMEWORK_NAME=Rosetta
xcrun llvm-cov export -format="lcov" .build/debug/${FRAMEWORK_NAME}PackageTests.xctest/Contents/MacOS/${FRAMEWORK_NAME}PackageTests -instr-profile .build/debug/codecov/default.profdata > info.lcov

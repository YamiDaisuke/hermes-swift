#!/bin/sh
GIT_DIR=$(git rev-parse --git-dir)
echo "Installing hooks…"
ln -s ../../scripts/pre-commit.sh $GIT_DIR/hooks/pre-commit
echo "Done!"

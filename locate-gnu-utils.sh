#!/bin/bash -ex

# BSD readlink and mktemp have different APIs from their GNU counterparts. On
# OSX systems we'll have g-prefixed GNU versions installed by Homebrew. Real
# BSD systems are still left in the cold.

READLINK=$(which readlink 2>/dev/null)
GREADLINK=$(which greadlink 2>/dev/null)
if [ -x "$GREADLINK" ]; then
  READLINK="$GREADLINK"
fi

MKTEMP=$(which mktemp 2>/dev/null)
GMKTEMP=$(which gmktemp 2>/dev/null)
if [ -x "$GMKTEMP" ]; then
  MKTEMP="$GMKTEMP"
fi

SHA256SUM=$(which sha256sum 2>/dev/null)
GSHA256SUM=$(which gsha256sum 2>/dev/null)
if [ -x "$GSHA256SUM" ]; then
  SHA256SUM="$GSHA256SUM"
fi

check_for_gnu_version() {
  gnu_available=$("$1" --version 2>&1 | grep GNU)
  if [ ! "$gnu_available" ]; then
    echo "Could not locate a GNU version of ${2}. This may mean you're using "\
         "a non-OSX BSD system, which these scripts don't know how to handle. "
    echo "If you are indeed using OSX, something may have gone wrong running "\
         "install-dev-dependencies.sh. Look for errors related to coreutils."
    exit 1
  fi
}

check_for_gnu_version "$MKTEMP" "mktemp"
check_for_gnu_version "$READLINK" "readlink"
check_for_gnu_version "$SHA256SUM" "sha256sum"

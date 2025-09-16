#!/bin/bash
# ============================================
# Build CTranslate2 on Apple Silicon with
# local libomp.a and headers
# ============================================

set -e # Exit on first error

# Define workspace paths
WORKSPACE="$HOME/desktop/productivity/code/LocalTranslateEnEs"
TRANSLATE_BUILD="$WORKSPACE/translator/build"
CTRANSLATE2_INSTALL="$WORKSPACE/ctranslate2-install"

# Clean previous build
rm -rf "$TRANSLATE_BUILD"
mkdir -p "$TRANSLATE_BUILD"
cd "$TRANSLATE_BUILD"

# Configure Translate and cmake it
cmake .. \
    -DCMAKE_PREFIX_PATH=$CTRANSLATE2_INSTALL \
    -DCMAKE_BUILD_TYPE=Release

# Build and install
make -j$(sysctl -n hw.ncpu)
# make install

echo "Translator built and installed in $TRANSLATE_BUILD"

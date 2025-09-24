#!/bin/bash
# ============================================
# CTranslate2 Build Script for Apple Silicon
# ============================================
set -e

# Workspace paths
WORKSPACE="$HOME/desktop/Productivity/Code/LocalTranslateEnEs"
CTRANSLATE2_SRC="$WORKSPACE/CTranslate2"
CTRANSLATE2_BUILD="$CTRANSLATE2_SRC/build"
CTRANSLATE2_INSTALL="$WORKSPACE/ctranslate2-install"
LIBOMP_PATH="$WORKSPACE/translator/libs"
LIBOMP_INCLUDE="$LIBOMP_PATH/include"
LIBOMP_STATIC_LIB="$LIBOMP_PATH/libomp.a"

# Clean previous build
rm -rf "$CTRANSLATE2_BUILD"
mkdir -p "$CTRANSLATE2_BUILD"
cd "$CTRANSLATE2_BUILD"

# Build CTranslate2, statically linking OpenMP
cmake .. \
  -DCMAKE_INSTALL_PREFIX="$CTRANSLATE2_INSTALL" \
  -DOPENMP_RUNTIME=COMP \
  -DWITH_ACCELERATE=ON \
  -DWITH_MKL=OFF \
  -DWITH_CUDA=OFF \
  -DWITH_DNNL=OFF \
  -DCMAKE_C_FLAGS="-Xpreprocessor -fopenmp -I$LIBOMP_INCLUDE" \
  -DCMAKE_CXX_FLAGS="-Xpreprocessor -fopenmp -I$LIBOMP_INCLUDE" \
  -DCMAKE_EXE_LINKER_FLAGS="-L$LIBOMP_PATH -lomp" \
  -DCMAKE_SHARED_LINKER_FLAGS="-L$LIBOMP_PATH -lomp" \
  -DOpenMP_C_FOUND=TRUE \
  -DOpenMP_CXX_FOUND=TRUE \
  -DOpenMP_C_FLAGS="-Xpreprocessor -fopenmp" \
  -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp" \
  -DOpenMP_C_LIBRARIES="$LIBOMP_STATIC_LIB" \
  -DOpenMP_CXX_LIBRARIES="$LIBOMP_STATIC_LIB" \
  -DOpenMP_FOUND=TRUE

# Build and install
make -j$(sysctl -n hw.ncpu)
make install

echo "CTranslate2 built and installed in $CTRANSLATE2_INSTALL"
echo "Make sure your translator project links to $CTRANSLATE2_INSTALL/lib and includes $CTRANSLATE2_INSTALL/include"

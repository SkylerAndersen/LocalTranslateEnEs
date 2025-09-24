cmake_minimum_required(VERSION 3.15)
project(translator-cli)
set(CMAKE_CXX_STANDARD 17)

# Tell CMake where to find CTranslate2 at compile time
set(CMAKE_PREFIX_PATH $ENV{HOME}/desktop/Productivity/Code/LocalTranslateEnEs/ctranslate2-install)
find_package(ctranslate2 REQUIRED)

# Tell CMake where to find CTranslate2 at run time
set(CMAKE_INSTALL_RPATH "@executable_path/lib")
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

# Add executable
add_executable(translator src/main.cpp)

# Add SentencePiece headers+lib.a
target_include_directories(translator PRIVATE
    ${CMAKE_SOURCE_DIR}/libs/include/sentence
)
target_link_libraries(translator PRIVATE
    CTranslate2::ctranslate2
    ${CMAKE_SOURCE_DIR}/libs/libsentencepiece.a
)

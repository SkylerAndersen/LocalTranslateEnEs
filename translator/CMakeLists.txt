cmake_minimum_required(VERSION 3.15)
project(translator-cli)

set(CMAKE_CXX_STANDARD 17)

# Tell CMake where to find CTranslate2
set(CMAKE_PREFIX_PATH $ENV{HOME}/desktop/Productivity/Code/LocalTranslateEnEs/ctranslate2-install)

find_package(ctranslate2 REQUIRED)

# Add your executable
add_executable(translator src/main.cpp)

# Add SentencePiece headers
target_include_directories(translator PRIVATE
    ${CMAKE_SOURCE_DIR}/libs/include/sentence
)

# Link against SentencePiece static library
target_link_libraries(translator PRIVATE
    CTranslate2::ctranslate2
    ${CMAKE_SOURCE_DIR}/libs/libsentencepiece.a
)

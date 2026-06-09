 
cmake_minimum_required(VERSION 3.16)
project(Whisper VERSION 1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt 6 Packages
find_package(Qt6 REQUIRED COMPONENTS Core )
qt_standard_project_setup()

# Define paths to whisper.cpp files
set(WHISPER_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/whisper.cpp)




# Include Whisper and GGML sources
set(WHISPER_SRCS
    ${WHISPER_ROOT}/src/whisper.cpp
    ${WHISPER_ROOT}/ggml/src/ggml.c
    ${WHISPER_ROOT}/ggml/src/ggml-alloc.c
    ${WHISPER_ROOT}/ggml/src/ggml-backend.cpp
    ${WHISPER_ROOT}/ggml/src/ggml-quants.c
)

# App target
qt_add_executable(Whisper
   # main.cpp
   whisperworker.h
   whisperworker.cpp
   ${WHISPER_SRCS}
)

# Include headers path
target_include_directories(Whisper PRIVATE
    ${WHISPER_ROOT}/include
    ${WHISPER_ROOT}/src
    ${WHISPER_ROOT}/ggml/include
)

# Link Libraries (whisper requires threading capabilities)
find_package(Threads REQUIRED)

target_link_libraries(Whisper PRIVATE    Qt6::Core
    Qt6::Qml
    Qt6::Network
    Threads::Threads)

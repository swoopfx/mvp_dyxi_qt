cmake_minimum_required(VERSION 3.20)
project(WhisperQtApp LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# -------------------------
# Qt
# -------------------------
find_package(Qt6 REQUIRED COMPONENTS Core Qml Network)
qt_standard_project_setup()

# -------------------------
# Whisper.cpp (IMPORTANT)
# -------------------------
set(WHISPER_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/whisper.cpp)

# Build whisper.cpp as a subproject (THIS FIXES EVERYTHING)
add_subdirectory(${WHISPER_ROOT})

# -------------------------
# App
# -------------------------
qt_add_executable(WhisperApp
    whisperworker.cpp
    whisperworker.h
    # main.cpp
)

# Link Libraries (whisper requires threading capabilities)
find_package(Threads REQUIRED)

target_link_libraries(WhisperApp PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::Network
    whisper
    Threads::Threads
)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:DebugDLL>")
add_definitions(-D_CRT_SECURE_NO_WARNINGS)

set(GGML_BACKEND_CPU ON CACHE BOOL "" FORCE)
set(GGML_OPENMP OFF CACHE BOOL "" FORCE)
set(GGML_VULKAN ON)
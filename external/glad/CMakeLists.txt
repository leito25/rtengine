cmake_minimum_required(VERSION 3.14)

project(glad)

add_library(glad STATIC
    src/glad.c
)

target_include_directories(glad PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Also add include path for glad.c to find glad.h with relative include
# and khrplatform.h from KHR directory
target_include_directories(glad PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include/glad
    ${CMAKE_CURRENT_SOURCE_DIR}/include/KHR
)

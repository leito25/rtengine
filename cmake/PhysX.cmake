# PhysX CMake Integration Module
# This module configures and builds NVIDIA PhysX as part of the project
# PhysX 4.1 requires special handling for macOS builds

include(ExternalProject)

# PhysX paths
set(PHYSX_ROOT_DIR "${CMAKE_SOURCE_DIR}/external/PhysX/physx" CACHE PATH "PhysX root directory")
set(PXSHARED_PATH "${CMAKE_SOURCE_DIR}/external/PhysX/pxshared" CACHE PATH "PxShared path")
set(CMAKEMODULES_PATH "${CMAKE_SOURCE_DIR}/external/PhysX/externals/cmakemodules" CACHE PATH "CMake modules path")

# Detect target platform
if(APPLE)
    if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
        set(PHYSX_PLATFORM "ios")
    else()
        set(PHYSX_PLATFORM "mac")
    endif()
elseif(WIN32)
    set(PHYSX_PLATFORM "windows")
elseif(UNIX)
    set(PHYSX_PLATFORM "linux")
endif()

# PhysX Build configuration
set(PHYSX_BUILD_TYPE "release" CACHE STRING "PhysX build type (debug, checked, profile, release)")
set(PHYSX_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/physx_install")

message(STATUS "")
message(STATUS "=== PhysX Configuration ===")
message(STATUS "PHYSX_ROOT_DIR: ${PHYSX_ROOT_DIR}")
message(STATUS "PXSHARED_PATH: ${PXSHARED_PATH}")
message(STATUS "PHYSX_PLATFORM: ${PHYSX_PLATFORM}")
message(STATUS "PHYSX_BUILD_TYPE: ${PHYSX_BUILD_TYPE}")
message(STATUS "")

# For PhysX 4.1 on macOS, we need to use their preset generator first
# This approach builds PhysX as an external project using their scripts

if(PHYSX_PLATFORM STREQUAL "mac")
    # Create a script to build PhysX
    set(PHYSX_BUILD_SCRIPT "${CMAKE_BINARY_DIR}/build_physx.sh")
    file(WRITE ${PHYSX_BUILD_SCRIPT}
"#!/bin/bash
cd \"${PHYSX_ROOT_DIR}\"
# Set environment variables
export PHYSX_ROOT_DIR=\"${PHYSX_ROOT_DIR}\"
export PM_PxShared_PATH=\"${PXSHARED_PATH}\"
export PM_CMakeModules_PATH=\"${CMAKEMODULES_PATH}\"
export PM_CMakeModules_NAME=\"CMakeModules\"
export PM_CMakeModules_VERSION=\"1.27\"

# Generate projects using PhysX script
./generate_projects.sh mac

# Build with make
cd compiler/mac64-Release
make -j$(sysctl -n hw.ncpu)
"
    )
    
    # Add external project for PhysX
    ExternalProject_Add(PhysX_External
        SOURCE_DIR ${PHYSX_ROOT_DIR}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${CMAKE_COMMAND} -E env 
            PHYSX_ROOT_DIR=${PHYSX_ROOT_DIR}
            PM_PxShared_PATH=${PXSHARED_PATH}
            PM_CMakeModules_PATH=${CMAKEMODULES_PATH}
            PM_CMakeModules_NAME=CMakeModules
            PM_CMakeModules_VERSION=1.27
            bash -c "cd ${PHYSX_ROOT_DIR} && ./generate_projects.sh mac || true"
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ""
        LOG_BUILD ON
    )
    
    # PhysX library directory (after build)
    set(PHYSX_LIB_DIR "${PHYSX_ROOT_DIR}/bin/mac.x86_64/release")
    
else()
    # For other platforms, use standard CMake approach
    set(PHYSX_LIB_DIR "${CMAKE_BINARY_DIR}/physx_build/lib")
endif()

# Create an interface library for easy linking (header-only for now)
add_library(physx_interface INTERFACE)

# PhysX include directories
target_include_directories(physx_interface INTERFACE
    ${PHYSX_ROOT_DIR}/include
    ${PXSHARED_PATH}/include
)

# Define the PhysX static library flag
target_compile_definitions(physx_interface INTERFACE
    PX_PHYSX_STATIC_LIB
)

# Note: Since PhysX builds as a separate project, users need to:
# 1. Run the PhysX preset generator first (./generate_projects.sh mac)
# 2. Build PhysX in its own directory
# 3. Link to the prebuilt libraries
#
# This is the recommended approach for PhysX 4.1 on macOS due to its
# complex build system requirements.

# Optionally, if prebuilt libraries exist, link them
if(EXISTS "${PHYSX_LIB_DIR}")
    # Find and link PhysX libraries
    find_library(PHYSX_LIB PhysX PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_COMMON_LIB PhysXCommon PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_FOUNDATION_LIB PhysXFoundation PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_EXTENSIONS_LIB PhysXExtensions PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_PVD_LIB PhysXPvdSDK PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_COOKING_LIB PhysXCooking PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_CHARACTER_LIB PhysXCharacterKinematic PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    find_library(PHYSX_VEHICLE_LIB PhysXVehicle PATHS ${PHYSX_LIB_DIR} NO_DEFAULT_PATH)
    
    if(PHYSX_LIB AND PHYSX_COMMON_LIB AND PHYSX_FOUNDATION_LIB)
        target_link_libraries(physx_interface INTERFACE
            ${PHYSX_LIB}
            ${PHYSX_COMMON_LIB}
            ${PHYSX_FOUNDATION_LIB}
            ${PHYSX_EXTENSIONS_LIB}
            ${PHYSX_PVD_LIB}
            ${PHYSX_COOKING_LIB}
            ${PHYSX_CHARACTER_LIB}
            ${PHYSX_VEHICLE_LIB}
        )
        message(STATUS "PhysX prebuilt libraries found and linked")
    else()
        message(WARNING "PhysX prebuilt libraries not found. Build PhysX separately first.")
        message(STATUS "To build PhysX:")
        message(STATUS "  cd ${PHYSX_ROOT_DIR}")
        message(STATUS "  ./generate_projects.sh ${PHYSX_PLATFORM}")
        message(STATUS "  cd compiler/${PHYSX_PLATFORM}64-Release")
        message(STATUS "  make -j$(nproc)")
    endif()
else()
    message(STATUS "PhysX library directory not found: ${PHYSX_LIB_DIR}")
    message(STATUS "PhysX headers are available for compilation.")
    message(STATUS "To build PhysX libraries:")
    message(STATUS "  cd ${PHYSX_ROOT_DIR}")
    message(STATUS "  ./generate_projects.sh ${PHYSX_PLATFORM}")
endif()

message(STATUS "PhysX integration configured (headers available)")

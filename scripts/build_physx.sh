#!/bin/bash

# Build PhysX for macOS/Linux
# This script builds NVIDIA PhysX 4.1 as a static library

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PHYSX_ROOT="$PROJECT_ROOT/external/PhysX/physx"
PXSHARED_PATH="$PROJECT_ROOT/external/PhysX/pxshared"
CMAKEMODULES_PATH="$PROJECT_ROOT/external/PhysX/externals/cmakemodules"

echo "=== Building PhysX ==="
echo "PHYSX_ROOT: $PHYSX_ROOT"
echo ""

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
else
    echo "Unsupported platform: $OSTYPE"
    exit 1
fi

echo "Platform: $PLATFORM"
echo ""

# Set environment variables
export PHYSX_ROOT_DIR="$PHYSX_ROOT"
export PM_PxShared_PATH="$PXSHARED_PATH"
export PM_CMakeModules_PATH="$CMAKEMODULES_PATH"
export PM_CMakeModules_NAME="CMakeModules"
export PM_CMakeModules_VERSION="1.27"

cd "$PHYSX_ROOT"

# Generate projects
echo "Generating PhysX projects..."
if [[ "$PLATFORM" == "mac" ]]; then
    ./generate_projects.sh mac
    BUILD_DIR="compiler/mac64"
elif [[ "$PLATFORM" == "linux" ]]; then
    ./generate_projects.sh linux
    BUILD_DIR="compiler/linux64"
fi

# Build
echo "Building PhysX..."
cd "$BUILD_DIR"
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo ""
echo "=== PhysX Build Complete ==="
echo "Libraries can be found in: $PHYSX_ROOT/bin/"
echo ""

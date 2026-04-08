#!/bin/bash

# RTEngine Setup Script
# This script initializes the project by setting up submodules and downloading GLAD

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== RTEngine Setup ==="
echo ""

# Initialize git submodules
echo "1. Initializing git submodules..."
cd "$PROJECT_ROOT"
git submodule update --init --recursive
echo "   Done!"
echo ""

# Create GLAD directories
echo "2. Setting up GLAD..."
mkdir -p "$PROJECT_ROOT/external/glad/include/glad"
mkdir -p "$PROJECT_ROOT/external/glad/include/KHR"
mkdir -p "$PROJECT_ROOT/external/glad/src"

# Download GLAD files using curl
echo "   Downloading GLAD files..."

# Download glad.h
curl -s -o "$PROJECT_ROOT/external/glad/include/glad/glad.h" \
    "https://raw.githubusercontent.com/nicebyte/glad/main/include/glad/glad.h" || {
    echo "   Note: Could not download glad.h automatically."
    echo "   Please visit https://glad.dav1d.de/ and generate GLAD files manually:"
    echo "   - Language: C/C++"
    echo "   - Specification: OpenGL"
    echo "   - Profile: Core"
    echo "   - API gl: Version 3.3 or higher"
    echo "   - Generate a loader: Yes"
    echo ""
    echo "   Then place the files:"
    echo "   - glad.h -> external/glad/include/glad/"
    echo "   - khrplatform.h -> external/glad/include/KHR/"
    echo "   - glad.c -> external/glad/src/"
}

# Download khrplatform.h
curl -s -o "$PROJECT_ROOT/external/glad/include/KHR/khrplatform.h" \
    "https://raw.githubusercontent.com/nicebyte/glad/main/include/KHR/khrplatform.h" || true

# Download glad.c
curl -s -o "$PROJECT_ROOT/external/glad/src/glad.c" \
    "https://raw.githubusercontent.com/nicebyte/glad/main/src/glad.c" || true

echo "   Done!"
echo ""

# Build the project
echo "3. Would you like to build the project now? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "   Building in Debug mode..."
    cmake -B "$PROJECT_ROOT/build/Debug" -S "$PROJECT_ROOT" -DCMAKE_BUILD_TYPE=Debug
    cmake --build "$PROJECT_ROOT/build/Debug" -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
    echo "   Done!"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To build manually:"
echo "  cmake -B build/Debug -S . -DCMAKE_BUILD_TYPE=Debug"
echo "  cmake --build build/Debug"
echo ""
echo "To run:"
echo "  ./build/Debug/bin/rtengine"
echo ""

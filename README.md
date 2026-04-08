# RTEngine - OpenGL CMake Project

A modern OpenGL project template using CMake and Git submodules, inspired by [OpenGL_CMake_Skeleton](https://github.com/arthursonzogni/OpenGL_CMake_Skeleton).

## Features

- Modern CMake (3.14+)
- OpenGL 3.3 Core Profile
- GLFW for window management
- GLM for mathematics
- GLAD for OpenGL loading
- VS Code integration with debug/release tasks

## Requirements

- CMake 3.14 or higher
- C++17 compatible compiler
- Git (for submodules)
- OpenGL 3.3+ compatible GPU

## Project Structure

```
rtengine/
├── CMakeLists.txt          # Main CMake configuration
├── .gitmodules             # Git submodule configuration
├── external/               # External dependencies (submodules)
│   ├── glfw/               # GLFW library
│   ├── glm/                # GLM mathematics library
│   └── glad/               # GLAD OpenGL loader
├── src/                    # Source files
│   └── main.cpp            # Main application
├── shaders/                # GLSL shader files
│   ├── vertex.glsl         # Vertex shader
│   └── fragment.glsl       # Fragment shader
├── assets/                 # Assets (textures, models, etc.)
└── .vscode/                # VS Code configuration
    ├── tasks.json          # Build and run tasks
    ├── launch.json         # Debug configurations
    └── c_cpp_properties.json # IntelliSense configuration
```

## Getting Started

### 1. Clone the Repository

```bash
git clone --recursive https://github.com/your-username/rtengine.git
cd rtengine
```

If you already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```

### 2. Generate GLAD Files

Before building, you need to generate GLAD files. Visit [GLAD Generator](https://glad.dav1d.de/) and:
- Language: C/C++
- Specification: OpenGL
- Profile: Core
- gl Version: 3.3 or higher
- Generate a loader: Yes

Download and extract:
- `glad.h` → `external/glad/include/glad/`
- `khrplatform.h` → `external/glad/include/KHR/`
- `glad.c` → `external/glad/src/`

Or use the provided script (if available):
```bash
./scripts/generate_glad.sh
```

### 3. Build the Project

#### Using VS Code Tasks (Recommended)

1. Open the project in VS Code
2. Press `Cmd+Shift+B` (macOS) or `Ctrl+Shift+B` (Windows/Linux)
3. Select one of the following tasks:
   - **Build Debug** - Build in debug mode
   - **Build Release** - Build in release mode
   - **Build and Run (Debug)** - Build and run in debug mode
   - **Build and Run (Release)** - Build and run in release mode

#### Using Command Line

**Debug Build:**
```bash
cmake -B build/Debug -S . -DCMAKE_BUILD_TYPE=Debug
cmake --build build/Debug -j8
./build/Debug/bin/rtengine
```

**Release Build:**
```bash
cmake -B build/Release -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build/Release -j8
./build/Release/bin/rtengine
```

### 4. Debugging in VS Code

1. Install the **C/C++** extension or **CodeLLDB** extension
2. Press `F5` or use the Debug panel
3. Select a debug configuration:
   - **Debug (lldb)** - For macOS (requires CodeLLDB)
   - **Debug (cppdbg - macOS)** - For macOS with Microsoft C/C++ extension
   - **Debug (cppdbg - Linux/GDB)** - For Linux
   - **Release (Run)** - Run release build

## VS Code Tasks

| Task | Description |
|------|-------------|
| `CMake Configure (Debug)` | Configure CMake for debug build |
| `CMake Configure (Release)` | Configure CMake for release build |
| `Build Debug` | Build the project in debug mode |
| `Build Release` | Build the project in release mode |
| `Run Debug` | Run the debug build |
| `Run Release` | Run the release build |
| `Build and Run (Debug)` | Build and run in debug mode |
| `Build and Run (Release)` | Build and run in release mode |
| `Clean` | Remove build directory |
| `Initialize Submodules` | Initialize git submodules |

## Controls

- `ESC` - Close the application

## Dependencies

- [GLFW](https://github.com/glfw/glfw) - Window and input handling
- [GLM](https://github.com/g-truc/glm) - OpenGL Mathematics
- [GLAD](https://glad.dav1d.de/) - OpenGL Loader Generator

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

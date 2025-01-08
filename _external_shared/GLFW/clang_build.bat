@echo off

:: This batch file builds GLFW from source code using Clang.
:: Place this script in the root GLFW folder and run it to build the static library.

:: Set the root folder as the location of this script
set "GLFW_ROOT=%~dp0"
set "BUILD_DIR=%GLFW_ROOT%build"
set "INSTALL_DIR=%GLFW_ROOT%glfw-install"

:: Paths to required tools
set PATH=C:\BuildTools\mingw-bin\bin;C:\BuildTools\cmake-bin\bin;C:\BuildTools\ninja-bin;%PATH%

:: Create the build directory
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%" || (
    echo [ERROR] Failed to access build directory.
    exit /b 1
)

:: Configure GLFW with CMake
cmake -G "Ninja" ^
  -DCMAKE_C_COMPILER=clang ^
  -DCMAKE_CXX_COMPILER=clang++ ^
  -DBUILD_SHARED_LIBS=OFF ^
  -DGLFW_BUILD_EXAMPLES=OFF ^
  -DGLFW_BUILD_TESTS=OFF ^
  -DGLFW_BUILD_DOCS=OFF ^
  -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" ^
  "%GLFW_ROOT%" || (
    echo [ERROR] CMake configuration failed.
    exit /b 1
)

:: Build GLFW with Ninja
ninja || (
    echo [ERROR] Build process failed.
    exit /b 1
)

:: Install GLFW
ninja install || (
    echo [ERROR] Install process failed.
    exit /b 1
)

:: Success message
echo [SUCCESS] GLFW built and installed successfully.
echo Static library: %INSTALL_DIR%\lib\libglfw3.a
echo Headers: %INSTALL_DIR%\include\GLFW

pause
exit /b

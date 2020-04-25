# ---- build_deps.ps1 -----
# Build libraries which are needed to build OpenVSLAM

Param([parameter(mandatory=$true)][string]$installDir)
$installDir = Resolve-Path $installDir
$sourceDir = Join-Path $installDir "\source"

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath

$buildTarget = "Visual Studio 16 2019"
$platform = "x64"
$buildType = "Release"

# create path variables
$lapackLibrary = (Join-Path $installDir "\lib\liblapack.lib").Replace("\", "/")
$blasLibrary = (Join-Path $installDir "\lib\libblas.lib").Replace("\", "/")

# gflags
Set-Location -Path (Join-Path $sourceDir "\gflags-2.2.2")
Remove-Item -Path "BUILD"
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir"
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir
# create path variables
$gflagsDir = (Join-Path $installDir "\lib\cmake\gflags").Replace("\", "/")

# glog
Set-Location -Path (Join-Path $sourceDir "\glog-0.4.0")
Remove-Item -Path "BUILD"
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -Dgflags_DIR="$gflagsDir"
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# yaml-cpp
Set-Location -Path (Join-Path $sourceDir "\yaml-cpp-0.6.3")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DYAML_MSVC_SHARED_RT=OFF `
  -DYAML_MSVC_STHREADED_RT=OFF `
  -DYAML_CPP_BUILD_TESTS=OFF `
  -DYAML_CPP_BUILD_TOOLS=OFF `
  -DYAML_CPP_BUILD_CONTRIB=OFF
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# SuiteSparse
Set-Location -Path (Join-Path $sourceDir "\suitesparse-1.5.0")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DLAPACK_LIBRARIES="$lapackLibrary" `
  -DBLAS_LIBRARIES="$blasLibrary"
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir
# create path variables
$cholmodIncludeDir = (Join-Path $installDir "\include\suitesparse").Replace("\", "/")
$cholmodLibrary = (Join-Path $installDir "\lib\libcholmod.lib").Replace("\", "/")
$csparseIncludeDir = (Join-Path $installDir "\include\suitesparse").Replace("\", "/")
$csparseLibrary = (Join-Path $installDir "\lib\libcxsparse.lib").Replace("\", "/")

# Eigen
Set-Location -Path (Join-Path $sourceDir "\eigen-3.3.7")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DLAPACK_LIBRARIES="$lapackLibrary" `
  -DBLAS_LIBRARIES="$blasLibrary" `
  -DCHOLMOD_INCLUDES="$cholmodIncludeDir" `
  -DCHOLMOD_LIBRARIES="$cholmodLibrary" 
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# g2o
Set-Location -Path (Join-Path $sourceDir "\g2o")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DBUILD_SHARED_LIBS=ON `
  -DBUILD_UNITTESTS=OFF `
  -DG2O_BUILD_EXAMPLES=OFF `
  -DLAPACK_LIBRARIES="$lapackLibrary" `
  -DBLAS_LIBRARIES="$blasLibrary" `
  -DCHOLMOD_INCLUDE_DIR="$cholmodIncludeDir" `
  -DCHOLMOD_LIBRARY="$cholmodLibrary" `
  -DBUILD_CSPARSE=OFF `
  -DCSPARSE_INCLUDE_DIR="$csparseIncludeDir" `
  -DCSPARSE_LIBRARY="$csparseLibrary"
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# OpenCV
Set-Location -Path (Join-Path $sourceDir "\opencv-3.4.8")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DLAPACK_LIBRARIES="$lapackLibrary" `
  -DBLAS_LIBRARIES="$blasLibrary" `
  -DENABLE_CXX11=ON `
  -DBUILD_DOCS=OFF `
  -DBUILD_EXAMPLES=OFF `
  -DBUILD_JASPER=OFF `
  -DBUILD_OPENEXR=OFF `
  -DBUILD_PERF_TESTS=OFF `
  -DBUILD_TESTS=OFF `
  -DWITH_EIGEN=ON `
  -DWITH_FFMPEG=ON `
  -DWITH_OPENMP=ON `
  -DWITH_CUDA=OFF `
  -DBUILD_opencv_calib3d=ON `
  -DBUILD_opencv_core=ON `
  -DBUILD_opencv_feature2d=ON `
  -DBUILD_opencv_highgui=ON `
  -DBUILD_opencv_imgcodecs=ON `
  -DBUILD_opencv_imgproc=ON `
  -DBUILD_opencv_videoio=ON `
  -DBUILD_opencv_world=ON `
  -DBUILD_opencv_apps=OFF `
  -DBUILD_opencv_dnn=OFF `
  -DBUILD_opencv_flann=OFF `
  -DBUILD_opencv_java_bindings_generator=OFF `
  -DBUILD_opencv_js=OFF `
  -DBUILD_opencv_ml=OFF `
  -DBUILD_opencv_objdetect=OFF `
  -DBUILD_opencv_photo=OFF `
  -DBUILD_opencv_python_bindings_generator=OFF `
  -DBUILD_opencv_python_tests=OFF `
  -DBUILD_opencv_shape=OFF `
  -DBUILD_opencv_stitching=OFF `
  -DBUILD_opencv_superres=OFF `
  -DBUILD_opencv_video=OFF `
  -DBUILD_opencv_videostab=OFF
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir
# create path variables
$opencvDir = (Join-Path $installDir "\x64\vc16\lib").Replace("\", "/")

# DBoW2
Set-Location -Path (Join-Path $sourceDir "\DBoW2")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DBUILD_SHARED_LIBS=OFF `
  -DOpenCV_DIR="$opencvDir"
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# Pangolin
Set-Location -Path (Join-Path $sourceDir "\Pangolin")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir"
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# socket.io-cpp-client
Set-Location -Path (Join-Path $sourceDir "\socket.io-client-cpp")
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake .. -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -DBUILD_SHARED_LIBS=OFF `
  -DBUILD_UNIT_TESTS=OFF
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

# Protocol Buffers
Set-Location -Path (Join-Path $sourceDir "\protobuf-3.11.4")
Remove-Item -Path "BUILD"
New-Item "build" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "build"
cmake ../cmake -G $buildTarget -A $platform `
  -DCMAKE_INSTALL_PREFIX="$installDir" `
  -Dprotobuf_BUILD_SHARED_LIBS=OFF `
  -Dprotobuf_BUILD_TESTS=OFF
MSBuild.exe INSTALL.vcxproj /p:Configuration=$buildType /p:ExceptionHandling=Sync /p:MultiProcessorCompilation=true
Set-Location -Path $scriptDir

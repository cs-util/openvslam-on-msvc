# ---- download_deps.ps1 -----
# Download libraries which are needed to build OpenVSLAM

Param([parameter(mandatory=$true)][string]$installDir)
$installDir = Resolve-Path $installDir
$sourceDir = Join-Path $installDir "\source"

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath

# make install directories
New-Item $installDir -ItemType Directory -ErrorAction SilentlyContinue
New-Item (Join-Path $installDir "\include") -ItemType Directory -ErrorAction SilentlyContinue
New-Item (Join-Path $installDir "\lib") -ItemType Directory -ErrorAction SilentlyContinue

# download LAPACK and BLAS
Set-Location -Path (Join-Path $installDir "\include")
Invoke-WebRequest -OutFile lapacke.h https://icl.cs.utk.edu/lapack-for-windows/include/lapacke.h
Invoke-WebRequest -OutFile lapacke_mangling.h https://icl.cs.utk.edu/lapack-for-windows/include/lapacke_mangling.h
Invoke-WebRequest -OutFile lapacke_config.h https://icl.cs.utk.edu/lapack-for-windows/include/lapacke_config.h
Invoke-WebRequest -OutFile lapacke_utils.h https://icl.cs.utk.edu/lapack-for-windows/include/lapacke_utils.h
Set-Location -Path (Join-Path $installDir "\lib")
Invoke-WebRequest -OutFile liblapack.lib https://icl.cs.utk.edu/lapack-for-windows/libraries/VisualStudio/3.7.0/Dynamic-MINGW/Win64/liblapack.lib
Invoke-WebRequest -OutFile liblapacke.lib https://icl.cs.utk.edu/lapack-for-windows/libraries/VisualStudio/3.7.0/Dynamic-MINGW/Win64/liblapacke.lib
Invoke-WebRequest -OutFile libblas.lib https://icl.cs.utk.edu/lapack-for-windows/libraries/VisualStudio/3.7.0/Dynamic-MINGW/Win64/libblas.lib

# move to source directory
New-Item $sourceDir -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path $sourceDir

# gflags
Invoke-WebRequest -OutFile gflags.zip https://github.com/gflags/gflags/archive/v2.2.2.zip
Expand-Archive -Path gflags.zip -DestinationPath .\ -Force
Remove-Item -Path gflags.zip

# glog
Invoke-WebRequest -OutFile glog.zip https://github.com/google/glog/archive/v0.4.0.zip
Expand-Archive -Path glog.zip -DestinationPath .\ -Force
Remove-Item -Path glog.zip

# yaml-cpp
Invoke-WebRequest -OutFile yaml-cpp.zip https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.3.zip
Expand-Archive -Path yaml-cpp.zip -DestinationPath .\ -Force
Remove-Item -Path yaml-cpp.zip
Rename-Item -Path yaml-cpp-yaml-cpp-0.6.3 -NewName yaml-cpp-0.6.3

# SuiteSparse
Invoke-WebRequest -OutFile suitesparse.zip https://github.com/jlblancoc/suitesparse-metis-for-windows/archive/v1.5.0.zip
Expand-Archive -Path suitesparse.zip -DestinationPath .\ -Force
Remove-Item -Path suitesparse.zip
Rename-Item -Path suitesparse-metis-for-windows-1.5.0 -NewName suitesparse-1.5.0

# Eigen
Invoke-WebRequest -OutFile eigen.zip https://github.com/eigenteam/eigen-git-mirror/archive/3.3.7.zip
Expand-Archive -Path eigen.zip -DestinationPath .\ -Force
Remove-Item -Path eigen.zip
Rename-Item -Path eigen-git-mirror-3.3.7 -NewName eigen-3.3.7

# g2o
git clone https://github.com/RainerKuemmerle/g2o.git

# OpenCV
Invoke-WebRequest -OutFile opencv.zip https://github.com/opencv/opencv/archive/3.4.8.zip
Expand-Archive -Path opencv.zip -DestinationPath .\ -Force
Remove-Item -Path opencv.zip

# DBoW2
git clone https://github.com/shinsumicco/DBoW2.git

# Pangolin
git clone https://github.com/stevenlovegrove/Pangolin.git

# socket.io-client-cpp
git clone --recursive https://github.com/shinsumicco/socket.io-client-cpp.git

# Protocol Buffers
Invoke-WebRequest -OutFile protobuf.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protobuf-cpp-3.11.4.zip
Expand-Archive -Path protobuf.zip -DestinationPath .\ -Force
Remove-Item -Path protobuf.zip

# move to the beginning directory
Set-Location -Path $scriptDir

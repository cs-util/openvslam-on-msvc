# PowerShell scripts for building OpenVSLAM with MSVC

## About

This repository contains PowerShell scripts for building OpenVSLAM with Microsoft Visual Studio.  
In order to avoid setting build configuration of OpenVSLAM via GUI, `MSBuild` is effectively used.  
Of course, you can also configure and build OpenVSLAM with Visual Studio IDE after running `cmake`.

## Instructions

### Step 0: Prerequisite 

Confirmed that these scripts work fine for the following environments:

- Windows PowerShell 5.1.18362.628
- CMake 3.16.4
- Visual Studio 2019 (with C++ features)

Please make sure that you can execute `cmake.exe` and `MSBuild.exe` on PowerShell.

### Step 1: Download dependencies

Run `.\download_deps.ps1` on PowerShell.  
Specify the directory which should contain source codes via a command-line argument.

```powershell
PS > .\download_deps.ps1 C:\path\to\directory\of\deps
```

Please wait until the download completes.

### Step 2: Build dependencies

Run `.\build_deps.ps1` on PowerShell.  
Specify the directory which includes `.\source` sub-directory via a command-line argument.

```powershell
PS > ls C:\path\to\directory\of\deps

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2099/12/31     12:05                include
d-----       2099/12/31     12:05                lib
d-----       2099/12/31     11:50                source

PS > .\build_deps.ps1 C:\path\to\directory\of\deps
```

Please wait until the build finishes.

### Step 3: Build OpenVSLAM

NOTE: The source codes in `master` branch is NOT currently compatible with the build with MSVC. **Please checkout `develop` branch.**

First, copy `.\build_app.ps1` to the root directory of OpenVSLAM.

```powershell
PS > cp .\build_app.ps1 C:\path\to\directory\of\openvslam
PS > cd C:\path\to\directory\of\openvslam
```

Then, run `.\build_app.ps1` by specifying the directory which contains the dependencies via a command-line argument.

```powershell
PS > ls C:\path\to\directory\of\deps

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       2099/12/31     12:01                CMake
d-----       2099/12/31     12:05                include
d-----       2099/12/31     12:05                lib
d-----       2099/12/31     11:50                source

PS > .\build_app.ps1 C:\path\to\directory\of\deps
```

After that, executable files of examples for OpenVSLAM will be created in `.\build` directory.

If you failed in running those executables due to link-failure, please copy the related libraries to `.\build` directory so that the executables can find the required libraries.

```powershell
PS > ls

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2099/12/31     12:09         393216 g2o_core.dll
-a----       2099/12/31     12:34          38400 g2o_csparse_extension.dll
-a----       2099/12/31     12:09          17408 g2o_opengl_helper.dll
-a----       2099/12/31     12:37         255488 g2o_solver_csparse.dll
-a----       2099/12/31     12:38         240128 g2o_solver_dense.dll
-a----       2099/12/31     12:39         250368 g2o_solver_eigen.dll
-a----       2099/12/31     12:07         165888 g2o_stuff.dll
-a----       2099/12/31     12:43         372224 g2o_types_sba.dll
-a----       2099/12/31     12:45         147968 g2o_types_sim3.dll
-a----       2099/12/31     12:23         429568 g2o_types_slam3d.dll
-a----       2099/12/31     13:03       46146560 opencv_world348.dll
-a----       2099/12/31     13:50        3817984 run_camera_localization.exe
-a----       2099/12/31     13:50        3779584 run_camera_slam.exe
-a----       2099/12/31     13:50        3814400 run_euroc_slam.exe
-a----       2099/12/31     13:50        3821568 run_image_localization.exe
-a----       2099/12/31     13:50        3772416 run_image_slam.exe
-a----       2099/12/31     13:51        3790336 run_kitti_slam.exe
-a----       2099/12/31     13:51        3781632 run_tum_rgbd_slam.exe
-a----       2099/12/31     13:51        3813888 run_video_localization.exe
-a----       2099/12/31     13:51        3764736 run_video_slam.exe
```

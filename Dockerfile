# escape=`

# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    # MSBuild tasks and targets for building Azure applications.
    #--add Microsoft.VisualStudio.Workload.AzureBuildTools `
    # Build SQL Server Database Projects
    #--add Microsoft.VisualStudio.Workload.DataBuildTools `
    # Tools for building WPF, Windows Forms, and console applications using C#, Visual Basic, and F#.
    --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools `
    # Provides the tools required to build MSBuild-based applications.
    --add Microsoft.VisualStudio.Workload.MSBuildTools `
    # Tools for building applications using .NET Core, ASP.NET Core, HTML/JavaScript, and Containers.
    --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `
    # MSBuild tasks and targets for building scalable network applications using Node.js, an asynchronous event-driven JavaScript runtime.
    #--add Microsoft.VisualStudio.Workload.NodeBuildTools `
    # Build Office and SharePoint add-ins, and VSTO add-ins.
    #--add Microsoft.VisualStudio.Workload.OfficeBuildTools `
    # Provides the tools required to build Universal Windows Platform applications.
    #--add Microsoft.VisualStudio.Workload.UniversalBuildTools `
    # Build Windows desktop applications using the Microsoft C++ toolset, ATL, or MFC.
    --add Microsoft.VisualStudio.Workload.VCTools `
    # Tools for building add-ons and extensions for Visual Studio, including new commands, code analyzers and tool windows.
    #--add Microsoft.VisualStudio.Workload.VisualStudioExtensionBuildTools `
    # MSBuild tasks and targets for building web applications.
    #--add Microsoft.VisualStudio.Workload.WebBuildTools `
    # Tools for building cross-platform applications for iOS, Android and Windows using C# and F#.
    #--add Microsoft.VisualStudio.Workload.XamarinBuildTools `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
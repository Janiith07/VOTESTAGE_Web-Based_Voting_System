@echo off
REM ============================================
REM Deploy VoteStage to Tomcat
REM ============================================

echo.
echo ========================================
echo VoteStage Deployment Script
echo ========================================
echo.

SET TOMCAT_WEBAPPS=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps
SET PROJECT_DIR=%~dp0VoteStage
SET DEPLOY_DIR=%TOMCAT_WEBAPPS%\VoteStage

echo Step 1: Checking if Tomcat is running...
tasklist /FI "IMAGENAME eq Tomcat9.exe" 2>NUL | find /I /N "Tomcat9.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [WARNING] Tomcat is running. Please stop it first!
    echo.
    echo To stop Tomcat:
    echo   1. Open Services (services.msc)
    echo   2. Find "Apache Tomcat 9.0 Tomcat9"
    echo   3. Click Stop
    echo.
    echo Press any key to continue anyway (not recommended)...
    pause >nul
)

echo.
echo Step 2: Creating deployment directory...
if not exist "%TOMCAT_WEBAPPS%" (
    echo [ERROR] Tomcat webapps directory not found!
    echo Expected: %TOMCAT_WEBAPPS%
    pause
    exit /b 1
)

echo Removing old deployment...
rmdir /S /Q "%DEPLOY_DIR%" 2>NUL

echo Creating new deployment directory...
mkdir "%DEPLOY_DIR%"

echo.
echo Step 3: Copying application files...

REM Copy webapp contents
echo Copying webapp files...
xcopy /E /I /Y "%PROJECT_DIR%\src\main\webapp\*" "%DEPLOY_DIR%"

REM Create WEB-INF directories if not exist
if not exist "%DEPLOY_DIR%\WEB-INF\classes" mkdir "%DEPLOY_DIR%\WEB-INF\classes"
if not exist "%DEPLOY_DIR%\WEB-INF\lib" mkdir "%DEPLOY_DIR%\WEB-INF\lib"

REM Copy compiled classes
echo Copying compiled classes...
if exist "%PROJECT_DIR%\target\classes" (
    xcopy /E /I /Y "%PROJECT_DIR%\target\classes\*" "%DEPLOY_DIR%\WEB-INF\classes\"
) else (
    echo [WARNING] No compiled classes found in target\classes
    echo Please build your project in your IDE first!
)

REM Copy libraries (if any in WEB-INF/lib)
if exist "%PROJECT_DIR%\src\main\webapp\WEB-INF\lib\*.jar" (
    echo Copying library files...
    copy /Y "%PROJECT_DIR%\src\main\webapp\WEB-INF\lib\*.jar" "%DEPLOY_DIR%\WEB-INF\lib\"
)

echo.
echo ========================================
echo Deployment Complete!
echo ========================================
echo.
echo Application deployed to: %DEPLOY_DIR%
echo.
echo Next Steps:
echo   1. Start Tomcat service (if not running)
echo   2. Wait 10-15 seconds for Tomcat to load the app
echo   3. Access: http://localhost:8080/VoteStage
echo.
echo To start Tomcat:
echo   - Open Services (Win+R, type: services.msc)
echo   - Find "Apache Tomcat 9.0 Tomcat9"
echo   - Click Start
echo.
pause










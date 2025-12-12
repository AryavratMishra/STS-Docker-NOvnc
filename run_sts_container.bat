@echo off
echo Starting STS Container...
docker compose up --build -d
if %errorlevel% neq 0 (
    echo Docker command failed. Trying classic 'docker-compose'...
    docker-compose up --build -d
)
if %errorlevel% neq 0 (
    echo.
    echo Error: Could not run docker commands. 
    echo Please make sure Docker Desktop is installed and running.
    pause
    exit /b 1
)
echo.
echo Container started successfully!
echo Access STS at: http://localhost:6901
echo Password: headless
echo.
pause

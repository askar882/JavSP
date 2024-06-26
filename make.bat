@echo off
REM Create exe from script

set activate=.venv\Scripts\activate.bat
set deactivate=.venv\Scripts\deactivate.bat
set ps_script=make\archive.ps1

IF NOT EXIST %activate% (
	@echo Creating virtual environment...
	python -m venv .venv
)

@echo Activating vitual environment...
call %activate%

@echo Installing required packages...
pip install -r requirements-noai.txt

echo JavSP version:
python make\gen_ver_hook.py ver_hook.py
pyinstaller --clean --noconfirm make\windows.spec

IF EXIST %ps_script% (
	powershell -executionPolicy bypass -file %ps_script%
	del %ps_script%
)
del ver_hook.py
del dist\config.ini 2>nul
rmdir /s /q build

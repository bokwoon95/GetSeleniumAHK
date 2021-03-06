﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;------------------------;
; Install Selenium Basic ;
;------------------------;

#Include SeleniumBasic2090.ahk
SplashTextOn, 600,100,Extracting Selenium,Please wait, extracting SeleniumBasic.exe`n`n(PRESS ESC TO ABORT ANYTIME)
WinMove, Extracting Selenium,,0,0
Extract_SeleniumBasic2090(A_ScriptDir . "\SeleniumBasic2090.exe")
SplashTextOff
Run SeleniumBasic2090.exe
WinWait Setup - Selenium Basic
WinActivate
Sleep 100

ControlClick, &Next >, Setup - Selenium Basic
; ControlClick, TNewButton1, Setup - Selenium Basic
Sleep 100

ControlClick, I &accept the agreement, Setup - Selenium Basic
; ControlClick, TNewRadioButton1, Setup - Selenium Basic
ControlClick, &Next >, Setup - Selenium Basic
; ControlClick, TNewButton2, Setup - Selenium Basic
Sleep 100

ControlClick, &Next >, Setup - Selenium Basic
; ControlClick, TNewButton2, Setup - Selenium Basic
Sleep 100

ControlClick, &Install, Setup - Selenium Basic
; ControlClick, TNewButton2, Setup - Selenium Basic

;--------------------------------;
; Obtain Latest chromedriver.exe ;
;--------------------------------;

; Get the latest version number by parsing html from https://sites.google.com/a/chromium.org/chromedriver/downloads
FileDelete %A_ScriptDir%\chromedriver.exe
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://sites.google.com/a/chromium.org/chromedriver/downloads", true)
whr.Send()
whr.WaitForResponse()
bigstring := whr.ResponseText
FoundPos := RegExMatch(bigstring, "U)<a name=""TOC-Latest-Release:-ChromeDriver-(.*)""></a>", LatestRelease)

SeleniumInstallPath := ""
if (FoundPos) {
    SplashTextOn, 600,150,Downloading chromedriver.zip,Please wait, downloading chromedriver.zip`n`n(PRESS ESC TO ABORT ANYTIME)
    WinMove, Downloading chromedriver.zip,,0,0
    ; UrlDownloadToFile, https://chromedriver.storage.googleapis.com/%LatestRelease1%/chromedriver_win32.zip, %A_ScriptDir%\chromedriver_win32.zip
    psScript =
    (
        param($url, $outfile)
        (New-Object System.Net.WebClient).DownloadFile($url, $outfile)
    )
    param1 = https://chromedriver.storage.googleapis.com/%LatestRelease1%/chromedriver_win32.zip
    param2 = %A_ScriptDir%\chromedriver_win32.zip
    RunWait PowerShell.exe -Command &{%psScript%} '%param1%' '%param2%',, hide
    SplashTextOff

    SplashTextOn, 600,150,Extracting 7za,Please wait, extracting 7za.exe`n`n(PRESS ESC TO ABORT ANYTIME)
    WinMove, Extracting 7za,,0,0
    #Include 7za.ahk
    Extract_7za(A_ScriptDir . "\7za.exe")
    SplashTextOff

    SplashTextOn, 600,150,Extracting chromedriver,Please wait, extracting chromedriver.exe`nEnter 'Y' if prompted to overwrite existing chromedriver.exe`n`n(PRESS ESC TO ABORT ANYTIME)
    WinMove, Extracting chromedriver,,0,0
    RunWait %ComSpec% /c ""%A_ScriptDir%\7za.exe" "e" "%A_ScriptDir%\chromedriver_win32.zip""
    SplashTextOff

    WinWaitClose, Setup - Selenium Basic
    if InStr(FileExist(A_ProgramFiles . "\SeleniumBasic"), "D") {
        SeleniumInstallPath := A_ProgramFiles . "\SeleniumBasic"
    } else if InStr(FileExist(A_AppData . "\..\Local\SeleniumBasic"), "D") {
        SeleniumInstallPath := A_AppData . "\..\Local\SeleniumBasic"
    }
    if (SeleniumInstallPath != "") {
        ; FileCopy, chromedriver.exe, %A_AppData%\..\Local\SeleniumBasic\, 1
        FileCopy, chromedriver.exe, %SeleniumInstallPath%\, 1
        Run %SeleniumInstallPath%\vbsc.exe
        FileDelete %A_ScriptDir%\chromedriver_win32.zip
        FileDelete %A_ScriptDir%\7za.exe
        FileDelete %A_ScriptDir%\SeleniumBasic2090.exe
        FileDelete %A_ScriptDir%\chromedriver.exe
    } else {
        MsgBox SeleniumBasic was not successfully installed
    }
} else {
    MsgBox Could not find the regex "U)<a name=""TOC-Latest-Release:-ChromeDriver-(.*)""></a>" in the URL https://sites.google.com/a/chromium.org/chromedriver/downloads
}
ExitApp

;------------------------------------------;
; SeleniumBasic Installer Wizard reference ;
;------------------------------------------;
; Setup - Selenium Basic
; ahk_class TWizardForm
; ahk_exe SeleniumBasic-2.0.9.0.tmp

Esc::ExitApp

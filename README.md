# GetSeleniumAHK

Get_SeleniumAHK_64bit.exe is a self-contained binary written in AutoHotKey that will

* Install [Selenium Basic](http://florentbr.github.io/SeleniumBasic/)
* Download the latest chromedriver from [https://sites.google.com/a/chromium.org/chromedriver/](https://sites.google.com/a/chromium.org/chromedriver/)
* Unzip chromedriver.zip into chromedriver.exe
* Copy the extracted chromedriver.exe into SeleniumBasic's install directory (either in C:\Users\\\<username>\AppData\SeleniumBasic or C:\Program Files\SeleniumBasic)
* Clean up the leftover files (SeleniumBasic.exe, chromedriver.zip, chromedriver.exe, 7za.exe etc)

To go into detail, Get_SeleniumAHK_64bit.exe itself contains the binaries for

1) Selenium Basic's installer
2) a portable version of 7zip, 7za.exe

It will extract these binaries out to the current directory before doing anything. AutoHotKey is able to embed these arbitrary files inside the script thanks to [this AutoHotKey script](https://autohotkey.com/board/topic/64481-include-virtually-any-file-in-a-script-exezipdlletc/). 7za.exe is required to unzip chromedriver.zip, because we cannot guarantee that the user already has a file decompression software installed (hence a portable version of 7zip is embedded).

**How Get_SeleniumAHK_64bit.exe downloads chromedriver**  
It parses the html of `https://sites.google.com/a/chromium.org/chromedriver/` to find the latest chromedriver version number. We only need the version number, because we can then download chromedriver.zip itself directly from the URL `https://chromedriver.storage.googleapis.com/<version number>/chromedriver_win32.zip`. AutoHotKey has an inbuilt command ['URLDownloadToFile'](https://autohotkey.com/docs/commands/URLDownloadToFile.htm) for downloading files, but I found it to be too slow for anything a few MB big, especially for computers with slow internet connection (I tried it on this ancient laptop, took forever). The best way I found was to invoke a PowerShell command `(New-Object System.Net.WebClient).DownloadFile($url, $outfile)` documented here ([3 ways to download files with PowerShell](https://blog.jourdant.me/post/3-ways-to-download-files-with-powershell)). This shortened the download time drastically from around a minute to a few seconds (if my memory serves).

Once chromedriver.zip is downloaded, the script will unzip it with the extracted 7za.exe and move chromedriver.exe into whichever directory Selenium Basic was installed in. Then, it will run vbsc.exe (located inside Selenium Basic's install directory) in order to make sure that the necessary DLLs are installed.

## Why this exists

AutoHotKey can do GUI automation, but it cannot do web browser automation [unless it uses Internet Explorer](http://www.blogbyben.com/2014/01/another-reason-to-love-autohotkey.html) (and who wants to use Internet Explorer?!). It can use Chrome, but only with Selenium Basic installed. However if you write an AutoHotKey script that uses Selenium Basic for some general-purpose office use, you can't guarantee that whoever is running that script also has Selenium Basic installed. How do you convince someone to use your script if they have to navigate to some webpage, download selenium basic, navigate to another webpage, download chromedriver, unzip it, figure out where selenium basic was installed so that they can copy the extracted chromedriver.exe for it to work? That's why this AutoHotKey script was made, to automate the installation process of Selenium Basic so that your AutoHotKey scripts that use Selenium Basic can work out of the box. 

<sub>note to self: apparently AutoHotKey already has an inbuilt function ['FileInstall'](https://www.autohotkey.com/docs/commands/FileInstall.htm) to embed files inside compiled .exe's that extract themselves when the .exe is run. Next time instead of embedding files using the AutoHotKey script, try using FileInstall instead.</sub>

# GetSeleniumAHK

Get_SeleniumAHK_64bit.exe is a self-contained binary that will install [Selenium Basic](http://florentbr.github.io/SeleniumBasic/) as well
as download the latest [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/) and place chromedriver.exe inside
SeleniumBasic's install directory. The user does not need Autohotkey installed, thanks to Autohotkey's ability to compile into 
Windows binaries. 

This is meant as an automated way for non-technical users to get Selenium Basic installed on their computer with the latest version of
chromedriver installed. This is so that other people can write Autohotkey scripts that utilize Selenium with the assumption that Selenium is already installed on the target computer, and if not all they have to do is to run the binary Get_SeleniumAHK_64bit.exe. (Rather than
guiding the user on installing Selenium Basic, downloading the latest chromedriver and unzipping it, and copying chromedriver.exe into
the install directory of Selenium Basic.)

# nineparchments-font

## About
This is font of the game [Nine Parchments](http://www.nineparchments.com/) company [Frozenbyte](http://frozenbyte.com/),
modified for support Russian,Ukrainian language.
All rights reserved to Frozenbyte company.

## Support
All questions regarding the support of the Russian font, write me an e-mail with a note "NINEFONT": **_dg.inc.lcf@gmail.com_"**
For other questions and suggestions, please contact: **_support@frozenbyte.com_**

## Install
For install this font in game you need tools from Trine 3.
* FB archiver v0.02 (archiver.exe)
* LUA compiler 32/64bit (luac.exe, luac_x64.exe)

Go to the game directory find **"script1.fbq"** **"gui1.fbq"** files and create a backup!(like "script1.fbq_orig")
Extract **"script1.fbq"** **"gui1.fbq"** archive to any directory with the FB archiver.
```
ex.
>archiver.exe -exctract=script1.fbq C:\Temp\script1
>archiver.exe -exctract=gui1.fbq C:\Temp\gui1
```
Clone repository, and compile two copy **"locale_settings.lua"** with LUA compiler.
```
ex. 
>luac.exe -o locale_settings.lub locale_settings.lua
>luac_x64.exe -o locale_settings.x64.lub locale_settings.lua
```
Go to directory with extracted files and replace original files with compiled earlier.
```
ex. C:\Temp\script1\data\script\misc
```
Then replace font file in our directory.
```
ex. C:\Temp\gui1\data\gui\font
```
Now you need to create archives. Create archives with the FB archiver.
```
ex.
>archiver.exe -create=script1.fbq C:\Temp\script1
>archiver.exe -create=gui1.fbq C:\Temp\gui1
```
And copy new **"script1.fbq"** **"gui1.fbq"** files in game directory. Done!

## Pictures
### Before
![alt-текст](../master/img/original_mainmenu.png "Before")
![alt-текст](../master/img/original_hitsandtips.png "Before")

### After
![alt-текст](../master/2018-10-15_13-19-01.png "After")
![alt-текст](../master/2018-10-15_13-20-20.png "After")
![alt-текст](../master/2018-10-15_13-21-18.png "After")

## Links
[Frozenbyte](http://frozenbyte.com/)

[Official game site](http://www.nineparchments.com/)

[Nine Parchments on Steam](https://store.steampowered.com/app/471550/Nine_Parchments/)

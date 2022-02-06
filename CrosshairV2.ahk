/*
AutoHotkey Version: 1.x
Language:	English
Platform:	Win9x/NT
Author:		tomoe_uehara
Script Function:
	Draws crosshair on the screen.
Date of Creation:
	14/09/2011 - 01:16:10
*/
#NoEnv
#SingleInstance, Force
#Include Gdip_All.ahk
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen

; ------- Configurable Section -------
CrosshairOpacity = E0
CrosshairColor = FF0000
CrosshairWidth = 2
Interval = 10	;in milisecond
; ------------------------------------

SetTimer, UPDATEDSCRIPT,1000
SetTimer, Check, %Interval%
If !pToken := Gdip_Startup() 
{ 
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system 
   ExitApp 
} 
OnExit, Exit 
Width := A_ScreenWidth, Height := A_ScreenHeight 
Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
Gui, 1: Show, NA, Gui98
WinSet, ExStyle, +0x20, Gui98
hwnd1 := WinExist() 
hbm := CreateDIBSection(Width, Height) 
hdc := CreateCompatibleDC() 
obm := SelectObject(hdc, hbm) 
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4) 
Gdip_GraphicsClear(G)

Draw:
MyPen = 0x%CrosshairOpacity%%CrosshairColor% 
pPen := Gdip_CreatePen(MyPen, CrosshairWidth)
MouseGetPos, xx, yy
; Amayui Castle Meister *1.5, offsetx = , offsety = 
muty := 1.50
mutx := 1.50
xx := xx * mutx + 0
yy := yy * muty - 15
currentx := xx
currenty := yy


DrawLine:
;Tooltip, x=%xx% y=%yy%
Gdip_DrawLine(G, pPen, xx - 50, yy, xx + 50, yy)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
Gdip_DrawLine(G, pPen, xx, yy - 50, xx, yy + 50)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
Gdip_DeletePen(pPen)
return

Redraw:
Gdip_GraphicsClear(G)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
Goto Draw

Check:
MouseGetPos, xx2, yy2
if (currentx != xx2) or (currenty != yy2)
{
	currentx := xx2
	currenty := yy2
	gosub Redraw
}
return

Exit: 
SelectObject(hdc, obm) 
DeleteObject(hbm) 
DeleteDC(hdc) 
Gdip_DeleteGraphics(G) 
Gdip_Shutdown(pToken) 
ExitApp 
Return

UPDATEDSCRIPT: 
FileGetAttrib,attribs,%A_ScriptFullPath% 
IfInString,attribs,A 
{ 
	FileSetAttrib,-A,%A_ScriptFullPath% 
	Sleep,500 
	Reload 
} 
Return
#SingleInstance

CoordMode "Pixel"

x::Reload ; Press X to Reload
^x::ExitApp ; Press Shift + X to Terminate

if not FileExist("settings.ini")
{
	IniWrite "", "settings.ini", "Settings", "PrivateSrverLink"
	IniWrite "Select File...", "settings.ini", "Settings", "SelectedAudioFile"
}

MyGui := Gui(,"Twisted Macro by oopsi9943")
MyGui.Add("Text", "Section w430", "Press X to reload application.")
MyGui.Add("Text", "Section w430", "Press Ctrl+X to terminate application.")
MyGui.Add("Text", "Section w430", "Private Server Link")
PSLink := MyGui.Add("Edit", "Section w430", IniRead("settings.ini", "Settings", "PrivateSrverLink"))
MyGui.Add("Text", "Section w430", "Audio file to play when finished (Optional)")
SelectedAudio := MyGui.Add("Button", "Default w80", IniRead("settings.ini", "Settings", "SelectedAudioFile"))
SB := MyGui.Add("StatusBar",, "Hello.")

RunMacro := MyGui.Add("Button", "Section w430 h50", "Start Macro")

MyGui.Show

MsgBox "Note: You will have to click where you spawn in the map yourself."


StartMacro(*)
{	
	loop {
		countval := 0
		errored := 0
		IniWrite PSLink.Text, "settings.ini", "Settings", "PrivateSrverLink"
		SB.SetText("Starting Macro...")
		Run(PSLink.Text)
		Loop {
			countval++
			Sleep 100
			if PixelSearch(&Px, &Py, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xAAFF7F, 2)
			{
				DllCall("SetCursorPos", "int", Px, "int", Py)
				sleep 100
				Click
				Send "\"
				sleep 1000
				Send "{Enter}"
				break
			}
			if countval > 300 {
				errored++
				ToolTip "No response after 30 seconds. Restarting..."
				SB.SetText("No response after 30 seconds. Restarting...")
				SetTimer () => ToolTip(), -5000
				break
			}
		}
		sleep 10
		Click
		countvaltwo := 0
		Loop {
			Sleep 100
			countvaltwo++
			if errored == 1
			{
				break
			}
			if PixelSearch(&Px, &Py, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xA69666, 0)
			{
				Send "\"
				sleep 500
				Send "D"
				sleep 200
				Send "S"
				sleep 200
				Send "S"
				sleep 200
				Send "D"
				sleep 200
				Send "D"
				sleep 200
				Send "D"
				sleep 500
				Send "{Enter}"
				break
			}
			if countvaltwo > 300 {
				errored++
				ToolTip "No response after 30 seconds. Restarting..."
				SB.SetText("No response after 30 seconds. Restarting...")
				SetTimer () => ToolTip(), -5000
				break
			}
		}
		sleep 1000
		if PixelSearch(&Px, &Py, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xFF7FFF, 0)
		{	
			SoundPlay IniRead("settings.ini", "Settings", "SelectedAudioFile")
			result := MsgBox("High day detected! Stop Searching?",, "YesNo")
			if (result = "Yes")
			{	
				ExitApp
			}
		}
		if errored == 0
		{
			sleep 500
			Send "!{F4}"	
		}
		sleep 500
		Send "^{W}"
	}
}

SelectFile(*)
{
	SelectedFile := FileSelect(3, , "Open a file", "Audio Files (*.mp3; *.wav; *.ogg)")
	if SelectedFile = ""
		SB.SetText("No file was selected!")
	else
		SB.SetText("Selected File: " . SelectedFile)
		IniWrite SelectedFile, "settings.ini", "Settings", "SelectedAudioFile"
}

RunMacro.OnEvent("Click", StartMacro)
SelectedAudio.OnEvent("Click", SelectFile)
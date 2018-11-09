Type=Activity
Version=7.01
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: True
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private btnCancel As Button
	Private btnLogin As Button
	Private edtPassword As EditText
	Private edtUsername As EditText
	Private lblPassword As Label
	Private lblTitle As Label
	Private lblUsername As Label
	Private myFont As Typeface
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("lytLogin")
	myFont=Typeface.LoadFromAssets("lato-light.ttf")
	If myFont.IsInitialized =True Then
		btnCancel.Typeface=myFont
		btnLogin.Typeface=myFont
		edtPassword.Typeface=myFont
		edtUsername.Typeface=myFont
		lblPassword.Typeface=myFont
		lblTitle.Typeface=myFont
		lblUsername.Typeface=myFont
	End If
End Sub

Sub Activity_Resume

End Sub

Sub Activity_KeyPress (KeyCode As Int) As Boolean
	'-----CHECK FOR KEYBOARD PRESESS----
	If KeyCode = KeyCodes.KEYCODE_BACK Then   'IF KEYPRESS IS BACK THEN CLOSE THE CURRENT VIEW AND GO BACK TO THE LAST VIEW
		'If sv1.Visible == True Then
		'	Return True
		'Else
		'OR CLOSE THE APPLICATION VIEW
		Activity.Finish
		Return True
		'End If
	Else
		Return False
	End If
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub edtPassword_EnterPressed
	
End Sub

Sub btnLogin_Click
	Main.loggedUser = True
	Msgbox2("You are now logged in. Please use the tool menu on the side bar.", Main.appLabel, "OK", "","",LoadBitmap(File.DirAssets,"ok.png"))
	Activity.Finish
End Sub

Sub btnCancel_Click
	Activity.Finish
End Sub
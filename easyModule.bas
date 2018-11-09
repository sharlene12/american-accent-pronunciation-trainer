Type=Activity
Version=7.3
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: True
	#IncludeTitle: False
#End Region

Sub Process_Globals
	Dim VR As VoiceRecognition
	Dim TTS1 As TTS
	Dim shouldIClose As Boolean = False
	Dim TTS1 As TTS
End Sub

Sub Globals
	Private lblMode As Label
	Private myFont,myFont2 As Typeface
	Private lblWordTitle As Label
	Private lblWordName As Label
	Dim A3, animRefresh As AnimationPlus
	Dim AnimSet, animSetRefresh As AnimationSet
	Private imgMic As ImageView
	Private lblSpeakNow As Label
	Dim wordList1word, wordList2word, wordListSentence As List
	Dim wordToGuess1Word, wordToGuess2Words, wordToGuessSentence, wordToGuess As String 
	Private imgBack As ImageView
	Private imgRefresh As ImageView
	Dim i As Intent
	Dim speakingFlag As Boolean = False
	Private pnlCategory As Panel
	Private img2word As ImageView
	Private img1word As ImageView
	Private imgsentence As ImageView

	Private isPanelVisible As Boolean = True
	Private imgPicTemplate As ImageView
	Private imgSpeak As ImageView
	Private wordNumber As Int = 0
	Dim MediaPlayer1 As MediaPlayer
	Dim MediaPlayer2 As MediaPlayer
	Private imgCorrect As ImageView
	Private lblCorrect As Label
	Private pnlCorrect As Panel
	Dim vanim As AnimationComposer
	Dim animationMap As Map
	
End Sub

Sub Activity_Create(FirstTime As Boolean)   ' insert all main features
	Activity.LoadLayout("easyLayout")
	myFont=Typeface.LoadFromAssets("arlrdbd.ttf")
	myFont2=Typeface.LoadFromAssets("Sofia-Regular.otf")
	lblMode.Typeface = myFont
	lblWordTitle.Typeface = myFont
	lblWordName.Typeface = myFont
	lblSpeakNow.Typeface = myFont
	lblSpeakNow.Visible = False
	lblCorrect.Typeface = myFont2
	
	If Main.gameLevel == "easy" Then
		wordList1word = File.ReadList(File.DirAssets, "easy1word.txt")
		wordList2word = File.ReadList(File.DirAssets, "easy2Words.txt")
		wordListSentence = File.ReadList(File.DirAssets, "easySentence.txt")
		lblMode.Text = "EASY"
		lblMode.TextColor = Colors.White
		lblWordTitle.Text = "1-WORD"
		
	else if Main.gameLevel == "intermediate" Then
		imgPicTemplate.Visible = False
		wordList1word = File.ReadList(File.DirAssets, "int1word.txt")
		wordList2word = File.ReadList(File.DirAssets, "int2Words.txt")
		wordListSentence = File.ReadList(File.DirAssets, "intSentence.txt")
		lblMode.TextColor = Colors.White
		lblMode.Text = "INTERMEDIATE"
		lblWordTitle.Text = "1-WORD"
		
	Else
		imgPicTemplate.Visible = False
		wordList1word = File.ReadList(File.DirAssets, "adv1word.txt")
		wordList2word = File.ReadList(File.DirAssets, "adv2Words.txt")
		wordListSentence = File.ReadList(File.DirAssets, "advSentence.txt")
		lblMode.TextColor = Colors.White
		lblMode.Text = "ADVANCED"
		lblWordTitle.Text = "1-WORD"
	End If
	
	VR.Initialize("VR")
	i.Initialize("android.speech.action.RECOGNIZE_SPEECH", "")
	i.PutExtra("SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS", 3000)
	TTS1.Initialize("TTS1")
	VR.Prompt = lblWordName.Text
	
	pnlCategory.Visible = True
	MediaPlayer1.Initialize()
	MediaPlayer1.Load(File.DirAssets, "wrong.mp3")

	MediaPlayer2.Initialize()
	MediaPlayer2.Load(File.DirAssets, "success.mp3")

	playSound

End Sub

Sub Activity_Resume
	If Main.isMuted == False Then
		MediaPlayer1.SetVolume(0.3,0.3)
		Main.MediaPlayer1.SetVolume(0.3,0.3)
		MediaPlayer2.SetVolume(0.2,0.2)
	Else
		MediaPlayer1.SetVolume(0,0)
		Main.MediaPlayer1.SetVolume(0,0)
		MediaPlayer2.SetVolume(0,0)
	End If
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	MediaPlayer1.SetVolume(0,0)
	MediaPlayer2.SetVolume(0,0)
	Main.MediaPlayer1.SetVolume(0,0)
End Sub

Sub TTS1_Ready (Success As Boolean)
	If Success Then
	Else
		Msgbox("Error initializing TTS engine.", "")
	End If
End Sub

Sub imgMic_Click      ' set the image Mic properties
	Main.MediaPlayer1.SetVolume(0,0)
	MediaPlayer1.SetVolume(0,0)
	Main.MediaPlayer2.SetVolume(0,0)
	If speakingFlag == False Then
'		A3.InitializeScaleCenter("Anim3", 0.6, 0.6,1, 1, imgMic)
'		A3.RepeatCount = A3.REPEAT_INFINITE
'		A3.RepeatMode = A3.REPEAT_REVERSE
'
'		AnimSet.Initialize(False)
'		AnimSet.AddAnimation(A3)
'		AnimSet.Duration = 600
'		AnimSet.PersistAfter = True
'		AnimSet.Start(imgMic)
		
		animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, imgMic)
		animRefresh.RepeatCount = 0
		animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

		animSetRefresh.Initialize(False)
		animSetRefresh.AddAnimation(animRefresh)
		animSetRefresh.Duration = 300
		animSetRefresh.PersistAfter = True
		animSetRefresh.Start(imgMic)
		
		'lblSpeakNow.Visible = True
		VR.Prompt = lblWordName.Text
		VR.Listen2(i) 'calls the voice recognition external activity
		speakingFlag = True
	Else
		AnimSet.Stop(imgMic)
		speakingFlag = False
		lblSpeakNow.Visible = False
	End If
End Sub

 Sub RandomNumber(Lowest As Double, Highest As Double, DecimalPlaces As Int, PreventZero As Boolean) As Double  ' Randomization
	Lowest  = Round(Lowest)
	Highest = Round(Highest)
	Dim Decimal As Double
	If DecimalPlaces > 0 Then Decimal = (Rnd(0, Power(10, DecimalPlaces))) / Power(10, DecimalPlaces)
	If Lowest = Highest Then
		Return Lowest
	Else
		If Lowest > Highest Then
			Dim TempValue = Lowest As Double
			Lowest   = Highest
			Highest  = TempValue
		End If
		Dim ReturnValue = Lowest + Rnd(0, Highest - Lowest) + Decimal As Double
		If ReturnValue = 0 And PreventZero Then
			Return RandomNumber(Lowest, Highest, DecimalPlaces, PreventZero)
		Else
			Return ReturnValue
		End If
	End If
End Sub 

Sub newWord ' set new words
	imgPicTemplate.Visible = True
	imgPicTemplate.Bitmap = LoadBitmap(File.DirAssets, "picturetemplate.png")
	If lblWordTitle.Text == "1-WORD" Then
		If wordList1word.Size > 0 Then
			wordNumber = RandomNumber(0, wordList1word.Size-1, 0, False)
			wordToGuess = wordList1word.Get(wordNumber)
			If Main.gameLevel == "easy" Then
				imgPicTemplate.Bitmap = LoadBitmap(File.DirAssets, wordToGuess & ".png")
				imgSpeak.Top = imgPicTemplate.Top + 17%y
				imgSpeak.Left = imgPicTemplate.left + 31%x
				imgSpeak.Height = 8%y
				imgSpeak.Width = 15%x
			End If
			wordList1word.RemoveAt(wordNumber)
		Else
			Dim dlgResponse As Int
			dlgResponse = Msgbox2("All items in the dictionary were used, reload?", Main.appLabel, "Yes", "Cancel","",LoadBitmap(File.DirAssets,"question.png"))
			If dlgResponse = DialogResponse.POSITIVE Then
				wordList1word.Clear
				If Main.gameLevel == "easy" Then
					wordList1word = File.ReadList(File.DirAssets, "easy1word.txt")
				else If Main.gameLevel == "intermediate" Then
					wordList1word = File.ReadList(File.DirAssets, "int1word.txt")					
				Else
					wordList1word = File.ReadList(File.DirAssets, "adv1word.txt")
				End If
				newWord
			Else
				' do nothing
			End If
		End If
			
	else if lblWordTitle.Text == "2-WORDS" Then
		imgPicTemplate.Visible = False
		imgSpeak.Top = lblWordTitle.Top + lblWordTitle.Height + 5%y
		imgSpeak.Left = 100%x/2 - 23%x
		imgSpeak.Height = 25%y
		imgSpeak.Width = 45%x
		If wordList2word.Size > 0 Then
			wordNumber = RandomNumber(0, wordList2word.Size-1, 0, False)
			wordToGuess = wordList2word.Get(wordNumber)
			wordList2word.RemoveAt(wordNumber)
		Else
			Dim dlgResponse As Int
			dlgResponse = Msgbox2("All items in the dictionary were used, reload?", Main.appLabel, "Yes", "Cancel","",LoadBitmap(File.DirAssets,"question.png"))
			If dlgResponse = DialogResponse.POSITIVE Then
				wordList2word.Clear
				If Main.gameLevel == "easy" Then
					
					wordList2word = File.ReadList(File.DirAssets, "easy2words.txt")			
				else If Main.gameLevel == "intermediate" Then
					wordList2word = File.ReadList(File.DirAssets, "int2words.txt")
				Else
					wordList2word = File.ReadList(File.DirAssets, "adv2words.txt")
				End If
				newWord
			Else
				' do nothing
			End If
		End If
	Else
		imgPicTemplate.Visible = False
		imgSpeak.Top = lblWordTitle.Top + lblWordTitle.Height + 5%y
		imgSpeak.Left = 100%x/2 - 23%x
		imgSpeak.Height = 25%y
		imgSpeak.Width = 45%x
		If wordListSentence.Size > 0 Then
			wordNumber = RandomNumber(0, wordListSentence.Size-1, 0, False)
			wordToGuess = wordListSentence.Get(wordNumber)
			wordListSentence.RemoveAt(wordNumber)
		Else
			Dim dlgResponse As Int
			dlgResponse = Msgbox2("All items in the dictionary were used, reload?", Main.appLabel, "Yes", "Cancel","",LoadBitmap(File.DirAssets,"question.png"))
			If dlgResponse = DialogResponse.POSITIVE Then
				wordListSentence.Clear
				If Main.gameLevel == "easy" Then
					wordListSentence = File.ReadList(File.DirAssets, "easysentence.txt")
				else If Main.gameLevel == "intermediate" Then
					wordListSentence = File.ReadList(File.DirAssets, "intsentence.txt")
				Else
					wordListSentence = File.ReadList(File.DirAssets, "advsentence.txt")
				End If
				newWord
			Else
				' do nothing
			End If
		End If
	End If

	lblWordName.Text = wordToGuess
	Log(wordToGuess)
End Sub

Sub imgRefresh_Click   ' set the image refresh properties
	playSound
	Main.MediaPlayer2.Play
	newWord
	animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, imgRefresh)
	animRefresh.RepeatCount = 0
	animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

	animSetRefresh.Initialize(False)
	animSetRefresh.AddAnimation(animRefresh)
	animSetRefresh.Duration = 300
	animSetRefresh.PersistAfter = True
	animSetRefresh.Start(imgRefresh)
	AnimSet.Stop(imgMic)
	speakingFlag = False
	lblSpeakNow.Visible = False
	
End Sub

Sub imgBack_Click  ' set the image back properties
	playSound
	Main.MediaPlayer2.Play
	animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, imgBack)
	animRefresh.RepeatCount = 0
	animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

	animSetRefresh.Initialize(False)
	animSetRefresh.AddAnimation(animRefresh)
	animSetRefresh.Duration = 300
	animSetRefresh.PersistAfter = True
	animSetRefresh.Start(imgBack)
	pnlCategory.Visible = True
	isPanelVisible = True
End Sub

Sub Activity_KeyPress (KeyCode As Int) As Boolean
	If KeyCode = KeyCodes.KEYCODE_BACK Then   'IF KEYPRESS IS BACK THEN CLOSE THE CURRENT VIEW AND GO BACK TO THE LAST VIEW
		If isPanelVisible ==  True Then
			Dim dlgResponse As Int
			dlgResponse = Msgbox2("Are you sure you want to stop this round?", Main.appLabel, "Yes", "Cancel","",LoadBitmap(File.DirAssets,"question.png"))
			If dlgResponse = DialogResponse.POSITIVE Then
				StartActivity(Main)
				playSound
				Main.MediaPlayer2.Play
				Activity.Finish
				Return True
			Else
				Return True
			End If
			Return False
		Else
			pnlCategory.Visible = True
			isPanelVisible = True
			playSound
			Main.MediaPlayer2.Play
			Return True
		End If
	End If
End Sub

Sub VR_Result (Success As Boolean, Texts As List)  ' display results
	If Success = True Then
		If Texts.Get(0) == lblWordName.Text Then
			pnlCorrect.Visible = True
			animationMap = vanim.Techniques
			vanim.Initialize("Anim",animationMap.GetValueAt(1))
			vanim.delay(500).duration(1500).playOn(lblCorrect)
			playSound
			MediaPlayer2.Play
			MediaPlayer2.Looping = False
			'Msgbox2("CORRECT! - " & Texts.Get(0), Main.appLabel, "OK", "","",LoadBitmap(File.DirAssets,"correct.png"))
			imgRefresh_Click
			playSound			
		Else 
			playSound
			MediaPlayer1.Play
			MediaPlayer1.Looping = False
			Msgbox2("Wrong word!" & CRLF & CRLF & "Word to Guess: " & lblWordName.Text & CRLF & CRLF & "Spoken word: " & Texts.Get(0), Main.appLabel, "OK", "","",LoadBitmap(File.DirAssets,"close2.png"))
			playSound
		End If
		AnimSet.Stop(imgMic)
		speakingFlag = False
		lblSpeakNow.Visible = False
	End If
End Sub

Sub imgsentence_Click ' set the image sentence properties
	playSound
	Main.MediaPlayer2.Play
	animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, imgsentence)
	animRefresh.RepeatCount = 0
	animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

	animSetRefresh.Initialize(False)
	animSetRefresh.AddAnimation(animRefresh)
	animSetRefresh.Duration = 300
	animSetRefresh.PersistAfter = True
	animSetRefresh.Start(imgsentence)
	pnlCategory.Visible = False
	isPanelVisible = False
	lblWordTitle.Text = "SENTENCE"
	newWord
End Sub

Sub img1word_Click ' set the image 1 word properties
	playSound
	Main.MediaPlayer2.Play
	animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, img1word)
	animRefresh.RepeatCount = 0
	animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

	animSetRefresh.Initialize(False)
	animSetRefresh.AddAnimation(animRefresh)
	animSetRefresh.Duration = 300
	animSetRefresh.PersistAfter = True
	animSetRefresh.Start(img1word)
	lblWordTitle.Text = "1-WORD"
	isPanelVisible = False
	pnlCategory.Visible = False
	newWord
End Sub


Sub img2word_Click ' set the image 2 words properties
	playSound
	Main.MediaPlayer2.Play
	animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, img2word)
	animRefresh.RepeatCount = 0
	animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

	animSetRefresh.Initialize(False)
	animSetRefresh.AddAnimation(animRefresh)
	animSetRefresh.Duration = 300
	animSetRefresh.PersistAfter = True
	animSetRefresh.Start(img2word)
	lblWordTitle.Text = "2-WORDS"
	isPanelVisible = False
	pnlCategory.Visible = False
	newWord
End Sub

Sub imgSpeak_Click ' set the image speak properties
	Main.MediaPlayer1.SetVolume(0,0)
	MediaPlayer1.SetVolume(0,0)
	Main.MediaPlayer2.SetVolume(0,0)
	animRefresh.InitializeScaleCenter("animRefresh", 0.8, 0.8,1, 1, imgSpeak)
	animRefresh.RepeatCount = 0
	animRefresh.RepeatMode = animRefresh.REPEAT_REVERSE

	animSetRefresh.Initialize(False)
	animSetRefresh.AddAnimation(animRefresh)
	animSetRefresh.Duration = 300
	animSetRefresh.PersistAfter = True
	animSetRefresh.Start(imgSpeak)
	TTS1.Speak(wordToGuess,True)
	playSound
End Sub

Sub playSound
	If Main.isMuted == False Then
		Main.MediaPlayer1.SetVolume(0.3,0.3)
		Main.MediaPlayer2.SetVolume(0.2,0.2)
		MediaPlayer1.SetVolume(1,1)
		MediaPlayer2.SetVolume(0.5,0.5)
	Else
		Main.MediaPlayer1.SetVolume(0,0)
		Main.MediaPlayer2.SetVolume(0,0)
		MediaPlayer1.SetVolume(0,0)
		MediaPlayer2.SetVolume(0,0)
	End If
End Sub

Sub pnlCorrect_Click
	pnlCorrect.Visible = False
End Sub

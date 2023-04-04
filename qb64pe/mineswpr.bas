Dim LevelWidth As _Unsigned _Byte
Dim LevelHeight As _Unsigned _Byte
Dim Mines As _Unsigned _Byte
While 1
    Input "Enter level width (1-16)", LevelWidth
    If (LevelWidth < 1) Or (LevelWidth > 16) Then _CONTINUE Else Exit
Wend

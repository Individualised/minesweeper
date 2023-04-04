Randomize Timer
Print "Minesweeper Game"
New = 1
While 1
    If NewGame(New) Then
        Print "You win!"; Chr$(35); "Would you like to play again? (Y to play again)"; Chr$(35)
        Input Choice$
        If UCase$(Left$(Choice$, 1)) = "Y" Then
            New = 1
            _Continue
        Else
            Exit While
        End If
    Else
        While 1
            Print "Game over!"; Chr$(35); "Would you like to (R)etry this level or generate a (N)ew level?"; Chr$(35)
            Input Choice
            Select Case Asc(UCase$(Left$(Choice$, 1)))
                Case 82
                    Print ("Retry")
                    New = 0
                    Exit While
                Case 78
                    Print ("New level")
                    New = 1
                    Exit While
                Case Else
                    Print ("Invalid")
                    _Continue
            End Select
        Wend
    End If

Wend


Function NewGame` (NewLevel)
    Dim LevelWidth As _Unsigned _Byte
    Dim LevelHeight As _Unsigned _Byte
    Dim Mines As _Unsigned _Byte
    While 1
        Input "Enter level width (1-16)", LevelWidth
        If LevelWidth < 1 Or LevelWidth > 16 Then _Continue Else Exit While
    Wend
    While 1
        Input "Enter level height (1-16)", LevelHeight
        If LevelHeight < 1 Or LevelHeight > 16 Then _Continue Else Exit While
    Wend
    While 1
        Input "Enter number of mines", Mines
        If Mines < 1 Or Mines > (LevelWidth * LevelHeight) - 1 Then _Continue Else Exit While
    Wend
    NewGame` = False

End Function



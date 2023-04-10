$Debug
Randomize Timer
Dim Shared As _Unsigned _Byte LevelWidth, LevelHeight, Mines
Dim Shared Level(16, 16) As _Bit
Print "Minesweeper Game"
New = 1
While -1
    If NewGame(New) Then
        Print "You win!"; Chr$(13); "Would you like to play again? (Y to play again)"
        Input Choice$
        If UCase$(Left$(Choice$, 1)) = "Y" Then
            New = 1
            _Continue
        Else
            Exit While
        End If
    Else
        While 1
            Print "Game over!"; Chr$(13); "Would you like to (R)etry this level or generate a (N)ew level?"
            Input Choice$
            Select Case Asc(UCase$(Left$(Choice$, 1)))
                Case 82
                    'Print ("Retry")
                    New = 0
                    Exit While
                Case 78
                    'Print ("New level")
                    New = 1
                    Exit While
                Case Else
                    'Print ("Invalid")
                    _Continue
            End Select
        Wend
    End If
Wend


Function NewGame` (NewLevel)
    If NewLevel Then
        While -1
            Input "Enter level width (1-16)", LevelWidth
            If LevelWidth < 1 Or LevelWidth > 16 Then _Continue Else Exit While
        Wend
        While -1
            Input "Enter level height (1-16)", LevelHeight
            If LevelHeight < 1 Or LevelHeight > 16 Then _Continue Else Exit While
        Wend
        While -1
            Input "Enter number of mines", Mines
            If Mines < 1 Or Mines > (LevelWidth * LevelHeight) - 1 Then _Continue Else Exit While
        Wend
        Call GenerateLevel(LevelWidth, LevelHeight, Mines)
        'For I = 0 To LevelHeight - 1
        '    For J = 0 To LevelWidth - 1
        '        Print Right$(Str$(Level(J, I)), 1);
        '    Next J
        '    Print
        'Next I
    End If
    NewGame` = GameLoop(LevelWidth, LevelHeight, Level(), Mines)
End Function

Sub GenerateLevel (W, H, M)
    Erase Level
    Print "Generating level... "
    While M <> 0
        'Print (M)
        RandX = RandRange(0, W)
        RandY = RandRange(0, H)
        'Print Right$(Hex$(RandX), 1); " "; Right$(Hex$(RandY), 1)
        If Level(RandX, RandY) = -1 Then
            _Continue
        Else
            Level(RandX, RandY) = -1
            'Print TempLevel(RandX, RandY)
            'Print TempLevel(RandX, RandY) = -1
            M = M - 1
        End If
    Wend
    'For I = 0 To H - 1
    '    For J = 0 To W - 1
    '        Print Right$(Str$(TempLevel(J, I)), 1);
    '    Next J
    '    Print
    'Next I
End Sub

Function RandRange% (I, J)
    RandRange% = (Int(Rnd * 1000) Mod J) + I
End Function

Function SquarePrint$1 (X, Y, L() As _Bit, U() As _Bit, F() As _Bit, ShowAll, Hit$)
    LM = 0
    If ShowAll = 0 Then
        If F(X, Y) = -1 Then
            SquarePrint$1 = "F"
            Exit Function
        End If
        If U(X, Y) = 0 Then
            SquarePrint$1 = "#"
            Exit Function
        End If
    Else
        If Hit$ <> "" And (Hex$(X) = "&H0" + Left$(Hit$, 1) And Hex$(Y) = "&H0" + Right$(Hit$, 1)) Then
            SquarePrint$1 = "!"
            Exit Function
        End If
    End If
    If L(X, Y) = -1 Then
        SquarePrint$1 = "*"
        Exit Function
    End If
    For I = 0 To 2
        For J = 0 To 2
            If X + (I - 1) < 0 Or Y + (J - 1) < 0 Then _Continue
            If X + (I - 1) > LevelWidth Or Y + (J - 1) > LevelHeight Then _Continue
            If L(X + (I - 1), Y + (J - 1)) = -1 Then
                LM = LM + 1
            End If
        Next J
    Next I
    SquarePrint$1 = Right$(Str$(LM), 1)
End Function


Function Replace$ (text$, old$, new$) 'can also be used as a SUB without the count assignment
    Do
        find = InStr(start + 1, text$, old$) 'find location of a word in text
        If find Then
            count = count + 1
            first$ = Left$(text$, find - 1) 'text before word including spaces
            last$ = Right$(text$, Len(text$) - (find + Len(old$) - 1)) 'text after word
            text$ = first$ + new$ + last$
        End If
        start = find
    Loop While find
    Replace$ = text$
End Function


Function GameLoop` (W, H, L() As _Bit, M)
    Dim Uncovered(W, H) As _Bit
    Dim Flags(W, H) As _Bit
    GameOver` = 0
    Won` = 0
    Move$ = ""
    FirstMove` = -1
    While -1
        Print W
        Print String$(Int(W / 2) + 3, " ");
        If Won` = -1 Then
            Print ":D"
        Else
            If GameOver` = -1 Then
                Print ":("
            Else
                Print ":)"
            End If
        End If
        Print "    "; Left$("0123456789ABCDEF", W); Chr$(13)
        If Won` = 0 Then t$ = Move$ Else t$ = ""
        For I = 0 To H - 1
            Print Right$(Hex$(I), 1); "   ";
            For J = 0 To W - 1
                Print SquarePrint(J, I, L(), Uncovered(), Flags(), (GameOver` Or Won`), t$);
            Next J
            Print
        Next I
        If GameOver` Then
            GameLoop` = 0
            Exit Function
        End If
        If Won` Then
            GameLoop` = -1
            Exit Function
        End If
        While -1
            Input "Make your move (X, Y, (U)ncover or (F)lag):", Move$
            'Move$ = Replace(Move$, ",", "")
            Move$ = Replace(Move$, " ", "")
            Move$ = Replace(Move$, ".", "")
            Move$ = UCase$(Move$)
            'Print Move$
            If Len(Move$) < 2 Then
                Print ("< 2")
                _Continue
            End If
            If Len(Move$) = 2 Then
                Print ("= 2")
                Move$ = Move$ + "U"
            End If
            If Right$(Left$(Move$, 3), 1) <> "U" And Right$(Left$(Move$, 3), 1) <> "F" Then
                Print ("!= U Or F")
                _Continue
            End If
            InvalidHex = -1
            For I = 0 To 15
                If Right$(Left$(Move$, 2), 1) = Right$(Hex$(I), 1) And Left$(Move$, 1) = Right$(Hex$(I), 1) Then
                    InvalidHex = 0
                    Exit For
                End If
            Next I
            If HexDigits(Left$(Move$, 1)) Or HexDigits(Right$(Left$(Move$, 2), 1)) Then
                Print ("Invalid Hex")
                _Continue
            End If
            If Val("&H" + Left$(Move$, 1)) > W - 1 Or Val("&H" + Right$(Left$(Move$, 2), 1)) > H - 1 Then
                Print ("Out of bounds")
                _Continue
            End If

            Exit While
        Wend

        If Right$(Left$(Move$, 3), 1) = "F" Then
            Flags(Val("&H" + Left$(Move$, 1)), Val("&H" + Right$(Left$(Move$, 2), 1))) = Not Flags(Val("&H" + Left$(Move$, 1)), Val("&H" + Right$(Left$(Move$, 2), 1)))
        Else
            If Not Flags(Val("&H" + Left$(Move$, 1)), Val("&H" + Right$(Left$(Move$, 2), 1))) Then
                Uncovered(Val("&H" + Left$(Move$, 1)), Val("&H" + Right$(Left$(Move$, 2), 1))) = -1
                If Level(Val("&H" + Left$(Move$, 1)), Val("&H" + Right$(Left$(Move$, 2), 1))) Then
                    If FirstMove` Then
                        Level(Val("&H" + Left$(Move$, 1)), Val("&H" + Right$(Left$(Move$, 2), 1))) = 0
                        While 1
                            RandX = RandRange(0, W)
                            RandY = RandRange(0, H)
                            'Print Right$(Hex$(RandX), 1); " "; Right$(Hex$(RandY), 1)
                            If Level(RandX, RandY) = 0 Then
                                Level(RandX, RandY) = -1
                                Exit While
                            End If
                        Wend
                    Else
                        GameOver` = -1
                    End If
                End If
                If Not GameOver` Then
                    K = 0
                    For I = 0 To H - 1
                        For J = 0 To W - 1
                            If Uncovered(J, I) Then
                                K = K + 1
                            End If
                        Next J
                    Next I
                    If K = (H * W) - Mines Then
                        Won` = -1
                    End If
                End If
                FirstMove` = 0
            End If
        End If
    Wend

End Function

Function HexDigits` (Character$)
    HexDigits` = 0
    For I = 0 To 15
        If Character$ = Right$(Hex$(I), 1) Then
            Exit Function
        End If
    Next I
    HexDigits` = -1
End Function

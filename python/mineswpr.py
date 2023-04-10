import random
import string

def newGame(newLevel):
    global levelWidth #hacky solution to retry level
    global levelHeight
    global mines
    global level
    if(newLevel):
        while 1:
            try:
                levelWidth = int(input("Enter level width (1-16)"))
            except ValueError:
                print("Invalid")
            else:
                if levelWidth < 1 or levelWidth > 16:
                    print("Invalid")
                else:
                    break
        
        while 1:
            try:
                levelHeight = int(input("Enter level height (1-16)"))
            except ValueError:
                print("Invalid")
            else:
                if levelHeight < 1 or levelHeight > 16:
                    print("Invalid")
                else:
                    break

        while 1:
            try:
                mines = int(input("Enter number of mines"))
            except ValueError:
                print("Invalid")
            else:
                if mines < 1 or mines > (levelWidth*levelHeight) - 1:
                    print("Invalid")
                else:

                    break
        level = generateLevel(levelWidth, levelHeight, mines)
    return(gameLoop(levelWidth, levelHeight, level, mines))
    #return(gameLoop(levelWidth, levelHeight, (generateLevel(levelWidth, levelHeight, mines))))

def generateLevel(w, h, m):
    level = [[0 for x in range(h)] for y in range(w)]
    print("Generating level... ")
    while m != 0:
        #print(str(m), end="")
        randX = random.randrange(0, w)
        randY = random.randrange(0, h)
        if level[randX][randY] == 1:
            #print("a")
            continue;
        else:
            level[randX][randY] = 1
            #print("b")
            m -= 1
    return level

def squarePrint(x, y, l, u, f, showAll, hit):
    m = 0
    if not showAll:
        if f[x][y] == 1:
            return("F")
        if u[x][y] == 0:
            return("#")
    else:
        if hit != None and (x == int(hit[0], 16) and y == int(hit[1], 16)):
            return("!")
    if l[x][y] == 1:
        return("*")
    for i in range(3):
        for j in range(3):
            try:
                if x + (i - 1) < 0 or y + (j - 1) < 0:
                    continue;
                l[x + (i - 1)][y + (j - 1)]
            except Exception:
                continue;
            else:
                if l[x + (i - 1)][y + (j - 1)] == 1:
                    m += 1
                    
    return(str(m))
        




    
def gameLoop(w, h, level, mines):
    uncovered = [[False for x in range(h)] for y in range(w)]
    flags = [[False for x in range(h)] for y in range(w)]
    gameOver = False;
    won = False;
    move = None;
    firstMove = True;
    while 1:
        #print(won)
        print(" " * (int(w/2) + 3) + (":D" if won else (":(" if gameOver else ":)")))
        print("    " + "0123456789ABCDEF"[:w] + "\n")
        #print(uncovered[1][0])
        for i in range(h):
            print(str(hex(i)[2:]).upper() + "   ", end="")
            for j in range(w):
                print(squarePrint(j, i, level, uncovered, flags, (gameOver or won), (move if not won else None)), end="")
            print("")
        if(gameOver):
            return False
        if(won):
            return True
        while 1:
            try:
                move = input("Make your move (X, Y, (U)ncover or (F)lag): ")
            except Exception:
                print("Invalid")
            else:
                move = move.replace(",", "")
                move = move.replace(" ", "")
                move = move.replace(".", "")
                move = move.upper()
                #print(move)
                if len(move) < 2:
                    print("Invalid")
                    continue;
                if len(move) == 2:
                    move += "U"
                if move[2] != "U" and move[2] != "F":
                    print("Invalid")
                    continue;
                if not(all(c in string.hexdigits for c in move[1]) and all(c in string.hexdigits for c in move[0])):
                    print("Invalid") 
                    continue;
                #print(int(move[0], 16), int(move[0], 16) > h - 1, int(move[1], 16), int(move[1], 16) > w - 1)
                if int(move[0], 16) > w - 1 or int(move[1], 16) > h - 1:
                    print("Invalid")
                    continue;                
                break;
               
        if move[2] == "F":
            flags[int(move[0], 16)][int(move[1], 16)] = not flags[int(move[0], 16)][int(move[1], 16)]         
        else:
            if not flags[int(move[0], 16)][int(move[1], 16)]:
                uncovered[int(move[0], 16)][int(move[1], 16)] = True
                if level[int(move[0], 16)][int(move[1], 16)]:
                    if firstMove:
                        while 1:
                            randX = random.randrange(0, w)
                            randY = random.randrange(0, h)
                            if level[randX][randY] == 0:
                                level[randX][randY] = 1
                                break;
                        level[int(move[0], 16)][int(move[1], 16)] = 0
                    else:
                        gameOver = True;
                if not gameOver:
                    k = 0
                    for i in range(h):
                        for j in range(w):
                            if uncovered[j][i] == 1:
                                k += 1
                    if k == (h * w) - mines:
                        won = True
                firstMove = False
                
                

    
    
random.seed()
print("Minesweeper Game")
new = True
while 1:
    if newGame(new):
        if input("You win!\nWould you like to play again? (Y to play again)\n")[0].upper() == "Y":
            new = True
            continue;
        else:
            break;
    else:
        while 1:
            match input("Game over!\nWould you like to (R)etry this level or generate a (N)ew level?")[0].upper():
                case "R":
                    new = False
                    break;
                case "N":
                    new = True
                    break;
                case _:
                    print("Invalid")
                    continue;
        continue;
            
    



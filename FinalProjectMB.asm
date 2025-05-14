;*****************************************************************************
; Author: Matthew Barber
; Date: 05/13/2025
; Description:
; This program works as an exploration game to find a city
; Notes:
; Numbers must be (0-9)
; Register Usage:
; R0 reserve for OUTPUT,INPUT operations 
; R1 used to check progress
; R2 used for State of player
; R3 used for calcs
; R4 used to store input from player
; R5 used for calculations
; R6 used to store information to the stack
; R7 used to traverse subroutines
.ORIG x3000
    JSR INITIATE
Redo

    JSR PRINT
RedoInputs
    AND R1, R1, #0
    JSR PRINTDECISIONS
    
    JSR RecieveInput
    
    JSR PROCESSINPUT
    
    ADD R3, R2, #-8
    BRz Zone9
    
    ADD R3, R1, R1
    BRz Redo
    
    ADD R3, R1, #-1
    BRz RedoInputs
    
Zone9
    JSR PRINT
    
	HALT 
	STACK .FILL xFE00
	AREA2a .FILL x334B
	AREA3a .FILL x34F0
	AREA4a .FILL x35E1
	AREA5a .FILL x3692
	AREA6a .FILL x3769
	AREA7a .FILL x38FF
	AREA8a .FILL x39FC
	AREA9a .FILL x3BAC
	AREA2backtrack .FILL x3C02
	AREA4backtrack .FILL x3C8F
	AREA6backtrack .Fill x3D00
	Zone3Wait1 .Fill x3D51
	Zone3Wait2 .Fill x3D9B
	DE1 .STRINGZ "1. "
	DE2 .STRINGZ "2. "
	DecForward .STRINGZ "Go Forward "
	DecBack .STRINGZ "Go Back"
	DecLeft .STRINGZ "Go Left "
	DecRight .STRINGZ "Go Right "
	DecWait .STRINGZ "Wait in line "
	DecCircle  .STRINGZ "Circle the lake "
	DecSwim .STRINGZ "Swim across the lake "
	REPEATPROMPT .STRINGZ "Invalid please enter a integer(1-2)."
	ASCTODEC .FILL #-48 ;converts ascii to decimal
	ENDLINE .FILL x0A ; A decimal 10, or a hex 'A'
    
;**INITIATE
;Initiates the program
;R2 sets to 0
;R6 sets to Stack
;R0 used to save prompt addressed to the stack
;
;**
INITIATE
    LD R6, STACK
    AND R5, R5, #0
    AND R1, R1, #0
    AND R2, R2, #0  ;set R2 to 0
    
    ADD R6, R6, #-1
    LD R0, Zone3Wait2
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, Zone3Wait1
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA6backtrack
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA4backtrack
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA2backtrack
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA9a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA8a
    STR R0, R6, #0
    
    ADD R6, R6, #-1 ;put prompt address into stack
    LD R0, AREA7a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA6a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA5a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA4a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA3a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LD R0, AREA2a
    STR R0, R6, #0
    
    ADD R6, R6, #-1
    LEA R0, AREA1 ;
    STR R0, R6, #0  ;add address of prompt to stack

    
    RET
;**
;**PRINT
;Prints the prompt based on argument R2
;R2 used to determine which area you are in
;R3 used for calcs
;R6 used for stack traversal
;R7 used for subroutine traversal
;
;**
PRINT
    ADD R6, R6, #-1
    STR R7, R6, #0   ;preserve registers in the stack
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R3, R6, #0
    
    
    AND R3, R3, #0 ;set R3 to 0
    ADD R3, R2, #0 ;set R3 to offset then negate
    NOT R3, R3
    ADD R3, R3, #1 
    
    
    ADD R6, R6, R2
    LDR R0, R6, #3      ;print prompt based on area, saved in stack 
    TRAP x22 
    
    
    LD R0, ENDLINE      ;creates endline
    TRAP x21
    TRAP x21
    
    
    ADD R6, R6, R3
    ;restore registers
    LDR R3, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
;**
;**PRINTDECISIONS
;Chooses the zone and its available desisions based off of argument n2
;R2 used to post options
;R6 sets to Stack
;R0 used to output
;
;**
PRINTDECISIONS
    ADD R6, R6, #-1
    STR R7, R6, #0   ;preserve registers in the stack
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R3, R6, #0
    
    
    LEA R0, DE1 
    TRAP x22
    
    ;option 1
    ADD R3, R2, #-1
    BRnz OP1
    
    ADD R3, R2, #-3
    Brz OP2
    
    ADD R3, R2, #-5
    Brz OP3
    
    LEA R0, DecForward
    TRAP x22
    BR TOND
    
OP1 ;n=0,1
    LEA R0, DecLeft
    TRAP x22
    BR TOND
    
OP2; n=3
    LEA R0, DecWait
    TRAP x22
    BR TOND
    
OP3; n= 5
    LEA R0, DecCircle
    TRAP x22
    
TOND
    LD R0, ENDLINE 
    TRAP x21
    
    LEA R0, DE2
    TRAP x22
    
    ;option 2
    ADD R3, R2, #-1
    BRnz OP1-2
    
    ADD R3, R2, #-3
    Brz OP2-2
    
    ADD R3, R2, #-5
    Brz OP3-2
    
    LEA R0, DecBack
    TRAP x22
    BR TOND-2
    
OP1-2 ;n=0,1
    LEA R0, DecRight
    TRAP x22
    BR TOND-2
    
OP2-2; n=3
    LEA R0, DecBack
    TRAP x22
    BR TOND-2
    
OP3-2; n= 5
    LEA R0, DecSwim
    TRAP x22
    
TOND-2
    
    LD R0, ENDLINE
    TRAP x21
    
    LEA R0, PROMPT 
    TRAP x22

    
    ;restore registers
    LDR R3, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
;**
;**RecieveInput
;Recieves input and converts to decimal, also validates the input
;R4 used to store input
;R3 used for calculation
;R5 used for calculations
;
;**
    RecieveInput
    ;preserve regesters
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R3, R6, #0

    

REPEAT

    LD R3, ASCTODEC
    TRAP x20
    ;read character without display
    ;the character stored in R0
    TRAP x21
    ;write the character
    ADD R4, R0, R3 ; save decimal argument to r4
    ;create new line
    LD R0, ENDLINE
    TRAP x21
    
    AND R3, R3, #0
    ADD R3, R3, #-2
    ADD R3, R3, R4
    Brnz UpperRange
    
    LEA R0, REPEATPROMPT
    TRAP x22
    BR REPEAT
    
UpperRange

    AND R3, R3, #0
    ADD R3, R3, #-1
    ADD R3, R3, R4
    BRzp CLEARED
    
    LEA R0, REPEATPROMPT
    TRAP x22
    BR REPEAT
    
CLEARED

    ;restore registers

    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
;**
;**
;**PROCESSINPUT
;Recieving integer 0-9 converts from decimal to ascii
;R4 used to store input
;R3 used for calculation
;
;**
PROCESSINPUT
    ;preserve regesters
    ADD R6, R6, #-1
    STR R7, R6, #0
    
    ADD R3, R2, R2     ;figure out n and go to the applicable zone
    Brz Zone0
    
    ADD R3, R2, #-1     
    Brz Zone1
    
    ADD R3, R2, #-2     
    Brz Zone2
    
    ADD R3, R2, #-3     
    Brz Zone3
    
    ADD R3, R2, #-4    
    Brz Zone4
    
    ADD R3, R2, #-5     
    Brz Zone5
    
    ADD R3, R2, #-6     
    Brz Zone6
    
;control options
    ADD R3, R4, #-1
    BRp Zone7-2        
    
    ADD R2, R2, #1  ;option 1 zone 7
    BR next
    
Zone7-2
    ADD R2, R2, #-2
    
    LDR R0, R6, #13
    TRAP x22
    
    LD R0, ENDLINE
    TRAP X21
    ADD R1, R1, #1
    
    BR next     ;option 2 zone 7

Zone0
    ADD R3, R4, #-1
    BRp Zone0-2
    
    ADD R2, R2, #1  ;option 1 zone 0
    BR next
    
Zone0-2
    ADD R2, R2, #2  ;option 2 zone 0
    BR next
    
    
Zone1
    ADD R3, R4, #-1
    BRp Zone1-2
    
    ADD R2, R2, #2  ;option 1 zone 1
    BR next
    
Zone1-2
    ADD R2, R2, #3  ;option 2 zone 1
    BR next
    
Zone2
    ADD R3, R4, #-1
    BRp Zone2-2     
    
    ADD R2, R2, #3  ;option 1 zone 2
    BR next 
    
Zone2-2
    ADD R2, R2, #-2 ;option 2 zone 2
    
    LDR R0, R6, #11
    TRAp x22
    
    LD R0, ENDLINE
    TRAP X21
    ADD R1, R1, #1
    BR next
    
Zone3
    ADD R3, R4, #-1 
    BRp Zone3-2
    ADD R3, R5, #0
    BRp TOTHE
    LDR R0, R6, #13 ;option 1 zone 3
    TRAP x22
    
    LD R0, ENDLINE
    TRAP X21
    ADD R5, R5, #1
    ADD R1, R1, #1
    BR next
TOTHE
    ADD R3, R5, #-1
    BRp LIMIT
    
    LDR R0, R6, #14 ;option 1 zone 3
    TRAP x22
    
    LD R0, ENDLINE
    TRAP X21
    
    ADD R5,R5, #1
    ADD R1, R1, #1
    BR next
LIMIT
    ADD R2, R2, #5  ;option 1 zone 1
    BR next
    
Zone3-2
    ADD R2, R2, #-2 ;option 2 zone 3
    BR next
    
Zone4
    ADD R3, R4, #-1 
    BRp Zone4-2
    
    ADD R2, R2, #2  ;option 1 zone 4
    BR next
    
Zone4-2
    ADD R2, R2, #-3 ;option 2 zone 4
    
    LDR R0, R6, #12
    TRAP x22
    
    LD R0, ENDLINE
    TRAP X21
    ADD R1, R1, #1
    
    BR next
    
Zone5
    ADD R3, R4, #-1 
    BRp Zone5-2
    
    ADD R2, R2, #1  ;option 1 zone 5
    BR next
    
Zone5-2
    ADD R2, R2, #2  ;option 2 zone 5
    BR next
    
Zone6
    ADD R3, R4, #-1 
    BRp Zone6-2
    
    ADD R2, R2, #2  ;option 1 zone 6
    BR next
    
Zone6-2
    ADD R2, R2, #-1 ;option 2 zone 6
    
    LDR R0, R6, #13
    TRAP x22
    
    LD R0, ENDLINE
    TRAP X21
    ADD R1, R1, #1
    
    BR next
    
next
    ;restore registers

    LDR R7, R6, #0
    ADD R6, R6, #1
    RET
;**
    PROMPT .STRINGZ "Where would you like to go: "
    AREA1 .STRINGZ "You awake in an opening of a forest, a struggling campfire coughs its last breaths as you shake off the last vestiges of sleep. You don’t have the supplies for another night, you must make it to the city. Ahead of you there are two paths, one a well trodden path where light pokes through the trees to the left and another less so trodden path along a creek travelling to the right. " 
    AREA2 .STRINGZ "You follow the path as the trees get thinner and thinner letting more and more light in ahead of you. As you exit the forest, you can clearly see the tall city walls and main gate before you. Leading out of the gate however is a large line of travelers being checked for contraband. You can either go down the left path to this line or try the right path, circling around the walls and possibly finding another entrance."
    AREA3 .STRINGZ "You follow the creak as it grows into a raging river, and as it leads out of the treeline you see the great walls of the city proper on the other side of the river. You could try to brave the river ahead or turn back to face the other path."
    AREA4 .STRINGZ "You finally reach the end of the line, it is gargantuan, you are not even close to the city gate and this could take hours. You can either wait or turn back to try another path"
    AREA5 .STRINGZ "You’ve reached about halfway around the city and have not spotted another entrance, you see what looks like another entrance ahead but it's another walk around the city. Or you can turn back and try another path."
    AREA6 .STRINGZ "You struggled against the pull of the river until ultimately surrendering to its pull. Some time while being dragged along you lost consciousness and awoke on what appears to be the shore of a lake. Across the lake you see the giant city walls and a break in the walls where you would find the city's port.You could swim across the lake taking a break at an island half way inside the lake or walk around."
    AREA7 .STRINGZ "You come across the edge of the city walls as they open to the grand trading port that opens to the lake. You see as ships pass in and out and a clear spot to enter the city by walking on the boardwalk. You can either continue this path or try another."
    AREA8 .STRINGZ "You’ve reached the halfway mark, you take a moment to rest and look over at the port. You watch as small vessels enter and leave the port freely. You would be able to freely enter the city if you could make it to the other side. This side is a little further however and the water is getting slightly more turbulent as the day starts to turn to night. You could attempt the last leg of the lake or turn back to find another path."
    AREA9 .STRINGZ "You have reached the safety of the city walls, congratualations you have won the game"
    AREA2back .STRINGZ "You follow the stream back to the river, the same paths are laid out before you. Left to the well trodden path and right to follow the creek"
    AREA4back .STRINGZ "You backtrack to fork in the road. You have the line to your left and the path circling the walls to your right."
    AREA6back .STRINGZ "You backtrack to the beach you woke up on, you can swim across or circle around."
    Wait1 .STRINGZ "The line slowly works it way through the gate, you're halfway to the city"
    Wait2 .STRINGZ "Theres only a handful of people, any minute and you'll be through the gate"
.END


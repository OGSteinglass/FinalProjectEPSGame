extends TileMap

enum State {BlackTurn, WhiteTurn, BlackWin, WhiteWin, Draw}

var curstate = State.BlackTurn
var moves_remaining = 60
#0 means empty. 1 means Black. 2 means White
var game_board =[
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,1,2,0,0,0],
	[0,0,0,2,1,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0]
]

#flips all the cells that should be flipped in the direction of the input

func flip_direction(x,y,color,dir, board):
	var i = x
	var j=y
	var target_color = color
	if color == 1:
		target_color = 2
	else:
		target_color = 1
	while j+dir.y <=7 and i +dir.x <=7 and j+dir.y>=0 and i+dir.x >=0: 
		#if the tile is the target color we need to see if our color is after it
		if board[j+dir.y][i+dir.x]==target_color:
			
			i+=dir.x
			j+=dir.y
		#if the tile is empty then we can stop
		elif board[j+dir.y][i+dir.x]==0:
			
			return
		#if the tile is our color we should go back and flip
		else:
			
			while i !=x or j!=y:
				board[j][i] = color
				i-=dir.x
				j-=dir.y
			return
		

func _ready():
	print_board(game_board)
	print("\n\n")
	move(1, 4,2,game_board)
	print_board(game_board)

func print_board(board):
	for i in board:
		print(i)
func move(color, x, y, board):
	board[y][x] = color
	flip_direction(x,y,color,Vector2i(0,1),board)
	flip_direction(x,y,color,Vector2i(-1,1),board)
	flip_direction(x,y,color,Vector2i(1,1),board)
	flip_direction(x,y,color,Vector2i(0,-1),board)
	flip_direction(x,y,color,Vector2i(-1,-1),board)
	flip_direction(x,y,color,Vector2i(1,-1),board)
	flip_direction(x,y,color,Vector2i(1,0),board)
	flip_direction(x,y,color,Vector2i(-1,0),board)
		
	

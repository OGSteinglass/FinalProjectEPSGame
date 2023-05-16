extends TileMap
var game_tile = preload("res://game_tile.tscn")
enum State {BlackTurn, WhiteTurn, BlackWin, WhiteWin, Draw}
const MOVE_WEIGHT = 4
const SCORE_WEIGHT = 1
const CORNER_WEIGHT = 32
const EDGE_WEIGHT = 5
var curstate = State.BlackTurn
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
var rendered_game_board = []


#flips all the cells that should be flipped in the direction of the input

func get_target_color(color):
	var target_color = 0
	if color == 1:
		target_color = 2
	else:
		target_color = 1
	return target_color
	
func flip_direction(x,y,color,dir, board):
	var i = x
	var j=y
	var target_color = get_target_color(color)
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
	
	for i in range(8):
		rendered_game_board.append([])
		for j in range(8):
			rendered_game_board[i].append(game_tile.instantiate())
			add_child(rendered_game_board[i][j])
			print("instatiated")
			rendered_game_board[i][j].position = map_to_local(Vector2(j,i))
	print_board(game_board)
	print_board(game_board)
	render(game_board)
func print_board(board):
	for i in board:
		print(i)
	print("Black score: "+str(score(board,1)))
	print("White score: "+str(score(board,2)))
	print("\n\n")

func move(color, x, y, board, real):
		board[y][x] = color
		flip_direction(x,y,color,Vector2i(0,1),board)
		flip_direction(x,y,color,Vector2i(-1,1),board)
		flip_direction(x,y,color,Vector2i(1,1),board)
		flip_direction(x,y,color,Vector2i(0,-1),board)
		flip_direction(x,y,color,Vector2i(-1,-1),board)
		flip_direction(x,y,color,Vector2i(1,-1),board)
		flip_direction(x,y,color,Vector2i(1,0),board)
		flip_direction(x,y,color,Vector2i(-1,0),board)
		if real:
			print_board(game_board)
			if curstate == State.BlackTurn:
				curstate = State.WhiteTurn
			elif curstate == State.WhiteTurn:
				curstate = State.BlackTurn
			#TODO make something happen when someone wins
			if score(board,1) + score(board,2) == 64:
				if score(board,1)>32:
					curstate=State.BlackWin
				elif score(board,2)>32:
					curstate=State.WhiteWin
				elif score(board,1)==score(board,2):
					curstate=State.Draw
			if score(board,1)==0:
				curstate=State.WhiteWin
			if score(board, 2) == 0:
				curstate=State.BlackWin	
	


func score(board, color):
	var score = 0
	for row in board:
		for i in row:
			if i == color:
				score+=1
	return score
	
func is_legal_move(board, color, x,y):
	if board[y][x] == 0:
		var test_board = board.duplicate(true)
		move(color, x,y,test_board, false)
		test_board[y][x]=0
		if test_board==board:
			return false
		else:
			return true	
	else:
		return false
#return a list of the x and y coordinates of legal moves
func get_legal_moves(board, color):
	var out = []
	for i in range(8):
		for j in range(8):
			if is_legal_move(board,color,j,i):
				out.append(Vector2i(j,i))
	return out
	
func evaluate(board, color, depth):
	
	if depth == 0:
		return simple_evaluate(board, color)
	else:
		var target_color = get_target_color(color)
		var moves = get_legal_moves(board,color)
		if score(board,1) + score(board,2) == 64:
			if score(board,color)>32:
					return 10000
			elif score(board,target_color)>32:
					return -10000
			elif score(board,color)==score(board,target_color):
					return 0
		if score(board, color)==0:
			return -10000
		if score(board, target_color) == 0:
			return 10000
		if len(moves) ==0:
			return -1*evaluate(board, target_color, depth-1)
		var best_move = Vector2i.ZERO
		var best_eval = -10000
		for i in range(len(moves)):
			var new_board = board.duplicate(true)
			
			move(color, moves[i].x, moves[i].y, new_board, false)
			return -1*evaluate(new_board,target_color,depth-1)
		
func simple_evaluate(board, color):
	var target_color = get_target_color(color)
	var moves = len(get_legal_moves(board,color))-len(get_legal_moves(board,target_color))
	var score = score(board, color)-score(board, target_color)
	var win = 0
	var corners =0
	var edges = 0
	if board[0][0] == color:
		corners+=1
	elif board[0][0] == target_color:
		corners-=1
	if board[0][7] == color:
		corners+=1
	elif board[0][7] == target_color:
		corners-=1
	if board[7][7] == color:
		corners+=1
	elif board[7][7] == target_color:
		corners-=1
	if board[7][0] == color:
		corners+=1
	elif board[7][0] == target_color:
		corners-=1
	for i in range(6):
		if board[0][i+1] == color:
			edges+=1
		elif board[0][i+1] == color:
			edges-=1
		if board[7][i+1] == color:
			edges+=1
		elif board[7][i+1] == color:
			edges-=1
		if board[i+1][0] == color:
			edges+=1
		elif board[i+1][0] == color:
			edges-=1
		if board[i+1][7] == color:
			edges+=1
		elif board[i+1][7] == color:
			edges-=1
	if score(board,target_color)==0:
		win = 100000
	if score(board, color) == 0:
		win = -100000
	if score(board,1) + score(board,2) == 64:
		if score(board,color)>32:
			win = 100000
		elif score(board,target_color)>32:
			win = -100000
		elif score(board,1)==score(board,2):
			win = 0 
	return moves*MOVE_WEIGHT+score*SCORE_WEIGHT+corners*CORNER_WEIGHT+edges*EDGE_WEIGHT+win


func get_best_move(board, color,depth):
	var target_color = get_target_color(color)
	var moves=get_legal_moves(board, color)
	var best_move=Vector2.ZERO
	var best_eval = -100000
	for i in range(len(moves)):
		var new_board = board.duplicate(true)
		
		move(color, moves[i].x, moves[i].y, new_board, false)
		if best_eval< evaluate(new_board,target_color,depth-1):
			best_move=moves[i]
	return best_move

func render(board):
	for i in range(8):
		for j in range(8):
			rendered_game_board[i][j].set_state(board[i][j])
			print(rendered_game_board[i][j].position)
			print(rendered_game_board[i][j].visible)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			var clicked_cell = local_to_map(event.position/scale.x-position/scale.x)
			print(clicked_cell)
			if clicked_cell.x<=7 and clicked_cell.x>=0 and clicked_cell.y<=7 and clicked_cell.y>=0:
				var color=0
				if curstate==State.BlackTurn:
					color=1
				if curstate==State.WhiteTurn:
					color=2
				if (is_legal_move(game_board,color,clicked_cell.x,clicked_cell.y)):
					move(color,clicked_cell.x,clicked_cell.y,game_board,true)
					render(game_board)
	

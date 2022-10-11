% Efficient and Interactive Game of Life

% Initializing the amount of rows/columns the user wants
rowsPrompt = "How many rows/columns would you like?\n";
ROWS = input(rowsPrompt);
COLUMNS = ROWS;

% Initializing the percentage of cells user wants to be alive
percentAlivePrompt = "What percentage of cells would you like to be alive? (enter as decimal)\n";
percentAlive = input(percentAlivePrompt);

% Creating board and also allowing user to choose board design
board = rand(ROWS, COLUMNS);
boardColorPrompt = "What board design would you like? Refer to MATLAB Colormap Table for all options.(Examples: 'gray', 'cool', 'winter', 'hot', etc -- Enter 'parula' for default)\n";
boardColor = input(boardColorPrompt);

% Allowing the user to choose the refresh rate of the board
timePrompt = "How many seconds do you want in between transitions?\n";
time = input(timePrompt);

%% Setting up the initial board state
% Logical indexing into board to get alive board
alive = board <= percentAlive;

% The alive board is the board itself -- 0 = dead, 1 = alive
board = alive;

%% Getting the adjacent values for each square

% Setting up temporary board to keep track of new values
tempBoard = board;

% N is the side length of the square board
N = ROWS;

% Shifting plus one and shifting minus one in board state
sp1 = [N 1:N-1];
sm1 = [2:N 1];

% Constantly updating the board using a temporary board 
while true
    % Getting the number of alive adjacent to each square
    adjacentValue = board(:,sm1)+board(:,sp1)+board(sm1,sm1)+board(sm1,:) ...
      +board(sm1,sp1)+board(sp1,sm1)+board(sp1,:)+board(sp1,sp1);
    
    % Going from Alive to Alive: Needs to be alive previously and have 2 or
    % 3 alive adjacent to it
    AA = board.*adjacentValue;
    AAupdate = tempBoard & (AA>=2 & AA<=3);
    
    % Going from Dead to Alive: Needs to be dead previously and have 3
    % alive adjacent to it
    DA = abs(board-1).*adjacentValue;
    DAupdate = ~tempBoard & (DA==3); 

    % All new alive are cells either going from alive to alive or dead to
    % alive
    tempBoard = (AAupdate | DAupdate);

    % Setting the board to the temporary board contents and displaying it
    % to the user
    board = tempBoard;
    imagesc(board);
    colormap(boardColor);
    pause(time);
end






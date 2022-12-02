% Efficient and Interactive Game of Life

% Initializing the amount of rows/columns the user wants
rowsPrompt = "How many rows/columns would you like?\n";
ROWS = input(rowsPrompt);
if isempty(ROWS)
   ROWS=200;            %DEFAULT
end
COLUMNS = ROWS;


% Initializing the percentage of cells user wants to be alive
percentAlivePrompt = "What percentage of cells would you like to be alive? (enter as decimal)\n";
percentAlive = input(percentAlivePrompt);
if isempty(percentAlive)
   percentAlive=0.4;            %DEFAULT
end

% Creating board and also allowing user to choose board design
board = rand(ROWS, COLUMNS);
boardColorPrompt = "What board design would you like? Refer to MATLAB Colormap Table for all options. (Examples: 'gray', 'cool', 'winter', 'hot', etc -- Enter 'parula' for default)\n";
boardColor = input(boardColorPrompt);
if isempty(boardColor)
   boardColor='winter';            %DEFAULT
end

% Allowing the user to choose the refresh rate of the board
timePrompt = "How many seconds do you want in between transitions?\n";
time = input(timePrompt);
if isempty(time)
   time = 0;
end

%% Setting up the initial board state
% Logical indexing into board to get alive board
alive = board <= percentAlive;

% Allowing the user to pick possible patterns that I hard coded in instead
% of the random gameboard. If they pick one, it overwwrites alive board.
wildcardPrompt = "Do you want to see any special patterns? (Options: 'copperhead', 'gliders', 'no')\n";
wildcard = input(wildcardPrompt, 's');
if strcmp(wildcard, 'copperhead') 
    c = [0 0 0 0 0 1 0 1 1 0 0 0;
         0 0 0 0 1 0 0 0 0 0 0 1;
         0 0 0 1 1 0 0 0 1 0 0 1;
         1 1 0 1 0 0 0 0 0 1 1 0;
         1 1 0 1 0 0 0 0 0 1 1 0;
         0 0 0 1 1 0 0 0 1 0 0 1;
         0 0 0 0 1 0 0 0 0 0 0 1;
         0 0 0 0 0 1 0 1 1 0 0 0;];
    alive = board*0; % Overwrite the alive board from earlier
    alive([ROWS/2:ROWS/2+size(c,1)-1],[COLUMNS/2:COLUMNS/2+size(c,2)-1])=c; 
elseif strcmp(wildcard, 'gliders') 
    g = [
        0     0     1     1     0     1     1     0     0
        0     1     0     1     0     1     0     1     0
        1     0     0     1     0     1     0     0     1
        0     1     0     1     0     1     0     1     0
        0     0     1     1     0     1     1     0     0
        ];
    alive = board*0; % Overwrites alive board
    alive([ROWS/2:ROWS/2+size(g,1)-1],[COLUMNS/2:COLUMNS/2+size(g,2)-1])=g;
end

% The alive board is the board itself -- 0 = dead, 1 = alive
board = alive;

lookback = 100;
boardHistory = zeros(lookback,ROWS,COLUMNS);
tempHistory = zeros(ROWS, COLUMNS);

%% Getting the adjacent values for each square

% Setting up temporary board to keep track of new values
tempBoard = board;

% N is the side length of the square board
N = ROWS;

% Shifting plus one and shifting minus one in board state
sp1 = [N 1:N-1];
sm1 = [2:N 1];
counter = 0;
b = true;
tickCounter = 2;
% Constantly updating the board using a temporary board. b is flag variable
% that will only leave the loop if it reaches oscillatory/equilibrium 
% behavior

%Graphics initialization
figure
hIm = imagesc(board);
colormap(boardColor);
hold on

while b == true
    counter = counter + 1;
    % Getting the number of alive adjacent to each square by adding all the
    % board states together (except for the given board state, which is board(:, :))
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

    % If boardHistory still has empty boards (meaning the tick counter <= 100)
    % Then just put the most recent board into the index matching 
    % the current counter
    if counter <= 100
        boardHistory(counter, :, :) = tempBoard;
    else
        boardHistory = circshift(boardHistory, -1);
        boardHistory(100, :, :) = tempBoard;
    end

    % If we haven't reached 100 board states yet, just compare most recent
    % board to the one before it to check for steady state. Also compare
    % most recent board to the board two boards before it to check for
    % oscillation with period of 2. Make sure to only check if we've
    % reached at least two ticks.

    if counter <= 100 & counter >= 2
        if boardHistory(counter, :, :) == boardHistory(counter - 1, :, :)
            b = false; 
            fprintf('The program ran for %d ticks before reaching a steady state.\n', counter);
        elseif (counter >= 3) & (boardHistory(counter, :, :) == boardHistory(counter - 2, :, :))
            b = false;
            fprintf('The program ran for %d ticks before oscillating with a period of 2.\n', counter);
        end
    end

    if counter > 100
        if boardHistory(100, :, :) == boardHistory(99, :, :)
            b = false; 
            fprintf('The program ran for %d ticks before reaching a steady state.\n', counter);
        elseif boardHistory(100, :, :) == boardHistory(98, :, :)
            b = false;
            fprintf('The program ran for %d ticks before oscillating with a period of 2.\n', counter);
        end
    end

    hIm.CData = tempBoard; %Update the data in handle imagesc (hIm)
    board = tempBoard;
    
    drawnow
    pause(time);
end

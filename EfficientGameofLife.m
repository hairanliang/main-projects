% Updated Game of Life

adjacentValue = 0;
t_max = 1000;
ROWS = 100;
COLUMNS = 100;
N = ROWS;

board = rand(ROWS, COLUMNS);

for row = 1:ROWS
   for column = 1:COLUMNS
      if board(row, column) < 0.5
         board(row, column) = 0;
      else
         board(row, column) = 1;
      end
   end
end

imagesc(board);

tempBoard = board;

sp1 = [N 1:N-1];
sm1 = [2:N 1];

while true
     adjacentValue = board(:,sm1)+board(:,sp1)+board(sm1,sm1)+board(sm1,:) ... 
     +board(sm1,sp1)+board(sp1,sm1)+board(sp1,:)+board(sp1,sp1);
     if adjacentValue == 1
                if adjacentValue == 1 | adjacentValue == 0
                tempBoard(row, column) = 0;
                elseif adjacentValue >= 4 
                tempBoard(row, column) = 0;
                else 
                tempBoard(row, column) = 1;
                end
            else
                if adjacentValue == 3
                    tempBoard(row, column) = 1;
                else
                    tempBoard(row, column) = 0;
                end
            end
end
    board = tempBoard;
    imagesc(board);
    pause(0.1);







% x = [ 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0;  0 0 0 0 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0; 0 0 0 1 1 1 0 0 0 0; 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0 0]
% Use this matrix as input. 
function output = gameOfLife(mat,n)     %Out is the output Matrix. Mat is the input matrix and n is the # of iterations.
    
    for r = 1:n                         %This for loop controls how many interations will occur.       
    [x,y] = size(mat);                  %Finding the x and y dimensions of our input matrix
    neighborSumMatrix = zeros(x,y);     %Creates a matrix to store how many alive neighbors a cell has.
    ringedMatrix = zeroRing(mat);       %Creates a perimeter of zero so that each value is located in the center.
    [x0,y0] = size(ringedMatrix);       %Finds the size of the new matrix with the ring.
    x2 = x0 - 1;                        %End of the original x coordinate translated to the zero ring matrix.
    y2 = y0 - 1;                        %End of the original y coordinate translated to the zero ring matrix
    
    for i = 2:x2                                        %Starting coordinate is 2 because that is the starting point of the original cell. 
        for j = 2:y2 
            sum = sumOfNeighbors(ringedMatrix,i,j);     %Calls a function I created to find how many neighbors are alive including itself.            
            neighborSumMatrix(i-1,j-1) = sum ;          %Stores the value of the neighboring sum in a new matrix. 
   
        end
    end
    usableMatrix = adjustedMatrix(mat,neighborSumMatrix); %Calls the function which takes the sum of neighbors and adjusts it so that it is usable for the rules of life.(Removes a value of 1 if it counted itself)
    
    matrixWithRules = rulesOfLife(usableMatrix,mat);       %This function implements the rules of life
    
    imagesc(mat)                                           %This allows us to visualize the matrix.
    pause(0.5)                                             %This is the interval between the changes in the visualized matrix to the next one.  
    mat = matrixWithRules;                                 %This takes the output and returns it as the input to the function.
    end
end



function sum = sumOfNeighbors(ringedMatrix,i,j)     %This function finds the sum of neighbors. Inputs are ringedMatrix for data, i and j for the coordinate of center. The i and j are part of the nested loop in the gameOflife function, therefore changes with each iteration.
    sum = 0;                                        %Total alive neighbors surrounding a cell. 
    for a = i-1:i+1                                 %This nested loop will count the values of the 8 surrounding cells including the target/center cell
        for b = j-1:j+1
            aliveNeighbors = ringedMatrix(a,b);             %Uses the coordinates in the for loop to count its neighbors. 
            sum = sum + aliveNeighbors;                     %Counts the total alive neighbors
            
        end
    end 
end 

function out = adjustedMatrix(mat,answer)     %This function adjusts the sumsOfNeighbors because the sumOfNeighbors includes the target cell value if it is 1.
[x,y] = size(mat);                            %Finds the dimensions of the input matrix.
out = zeros(x,y);                             %Creates the output function with the dimenions of the input function filled with zeros.
  for k = 1:x                                 
        for l = 1:y                          
            if mat(k,l) == 1                  %This for loop adjusts the sumsOfNeighbors because the function summed the target cell if it was also a 1
                val = answer(k,l);            %Creates a loop that iterates through each index within the matrix.
                out(k,l) = val - 1;           %If the original target cell is alive, remove a value of 1 from the sum in the data for sumOfNeighbors.
            else
                out(k,l) = answer(k,l);        %If the original cell has dead or '0', it doesnt remove any values from the matrix.
            end    
        end 
	end 
end

function finalMatrix = rulesOfLife(usableMatrix,mat) %This function takes the matrix who has the correct # of neighbor values which doesn't include itself and applies the rules of life into it.
    [x,y] = size(usableMatrix);                 %This line gives us the dimenions of the input matrix.
     finalMatrix  = zeros(x,y);                 %This line creates a matrix of zeros with the same size as the input matrix. This will be our ouput matrix.
        for i = 1:x                             %Creates a loop that iterates through each index within the matrix.
            for j = 1:y
                if (mat(i,j)== 1) && (usableMatrix(i,j) == 2 || usableMatrix(i,j) == 3) %First condition for rule of life.
                    finalMatrix(i,j) = 1;
                elseif (mat(i,j)== 0) && (usableMatrix(i,j) == 3)                       %Second condition for the rule of life.
                    finalMatrix(i,j) = 1;
                else 
                    finalMatrix(i,j) = 0;                                               %All other conditions for the rule of life. 
                end
            end
        end
end 

function ringedMatrix = zeroRing(mat)   %This function gives us a border around our original function.
[x,y] = size(mat);                      %This line gives us the dimenions of the original matrix.           

ringedMatrix = zeros(x+2,y+2);          %This line creates a matrix of zeros with two extra rows and columns.

ringedMatrix(2:x+1,2:y+1) = mat;        %This line takes our original matrix and centers it into the new matrix. 

end
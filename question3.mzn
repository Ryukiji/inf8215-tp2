include "globals.mzn"; 

int: n; % num rows and columns
set of int: SIZE = 1..n;

int: L = 1; % Lamp
int: P = 2; % Plant

% 1 for a lamp, 2 for a plant and 0 for nothing 
array[SIZE,SIZE] of 0..2: garden;

% number of plants by row/col
array[SIZE] of int: rows;
array[SIZE] of int: cols;

% decision variables
array[SIZE,SIZE] of var 0..P: x;

% lamp placement
constraint forall(i, j in SIZE) (
  if garden[i, j] = L
    then x[i, j] = L
  endif);
% constraints on rows and columns
constraint forall(i in SIZE)(
  count(val in [x[i, j] | j in SIZE])(
    val = P) = 
    rows[i]);
constraint forall(j in SIZE)(
  count(val in [x[i, j] | i in SIZE])(
    val = P) = 
    cols[j]);
% plants cannot touch in any direction
constraint forall(i, j in SIZE) (
  if x[i,j] = P
    then count(val in 
      [x[k, l] | 
        k in 
          if i>1 then i-1 else 1 endif ..
          if i<n then i+1 else n endif,
        l in 
          if j>1 then j-1 else 1 endif ..
          if j<n then j+1 else n endif])(
      val = P) = 
      1
  endif);

% each plant must be next to at least one lamp horizontally or vertically
constraint forall(i, j in SIZE) (
  if x[i, j] = P
    then count(val in
      [x[k, j] | k in 
        if i>1 then i-1 else 1 endif ..
        if i<n then i+1 else n endif])(
      val = L) +
    count(val in
      [x[i, l] | l in 
        if j>1 then j-1 else 1 endif ..
        if j<n then j+1 else n endif])(
      val = L) >= 
      1
  endif);

% each lamp must be next to at least one plant horizontally or vertically
constraint forall(i, j in SIZE)(
  if x[i,j] = L
    then count(val in
      [x[k, j] | k in 
        if i>1 then i-1 else 1 endif ..
        if i<n then i+1 else n endif])(
      val = P) +
    count(val in
      [x[i, l] | l in 
        if j>1 then j-1 else 1 endif ..
        if j<n then j+1 else n endif])(
      val = P) >= 
      1
  endif);

solve satisfy;

output 
[
 if j = 1 then "\n" ++ show(rows[i]) ++ " " else " " endif ++
   if fix(x[i,j]) = L then "L" elseif fix(x[i,j]) = P then "P" else "_" endif
| i,j in 1..n
] ++ ["\n  "] ++ [show(cols[i]) ++ " " | i in 1..n];

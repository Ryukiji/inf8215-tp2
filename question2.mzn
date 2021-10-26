include "globals.mzn"; 

int: n = 5;
set of int: SIZE = 1..n;
% the given results
array[1..4] of int: res = [1,2,5,7];

% number of points for each player
array[SIZE] of var 0..3*n: x;

% (i, j) is the result of player i against player j
array[SIZE, SIZE] of var {0,1,3}: matches;

% Points
constraint forall(i in 1..n-1)(
  x[i] = res[i]);
% Sum of points earned equals score
constraint forall(i in SIZE)(
  sum([matches[i, j] | j in SIZE]) = x[i]);
% Score constraints
constraint forall(i in SIZE)(
  matches[i, i] = 0);
constraint forall(i, j in SIZE)(
  if i != j
    then if matches[i, j] = 1
      then matches[j, i] = 1
    elseif matches[i, j] = 0
      then matches[j, i] = 3
    else matches[j, i] = 0
    endif
  else matches[i, i] = 0
  endif);

solve satisfy;

output 
[
  "Scores\n"
]
++
[
  show(x)
]
++	
[
  "\nMatches\n"
]
++
[ show(matches[i,j]) ++ 
         if j == n then "\n" else " " endif |
         i in 1..n, j in 1..n
]
;
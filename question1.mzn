include "globals.mzn";

int: r;
int: c;

% Garden definition
set of int: HEIGHT = 1..r;
set of int: WIDTH = 1..c;
array[HEIGHT] of int: rowinsects;
array[WIDTH] of int: colinsects;

array[HEIGHT, WIDTH] of var int: knownpositions;
array[HEIGHT,WIDTH] of var int: garden; % Number of bugs on (i, j)

% All different in rows and columns
constraint forall (i in HEIGHT) (
                   alldifferent([garden[i,j] | j in WIDTH])); 
constraint forall (j in WIDTH) (
                   alldifferent([garden[i,j] | i in HEIGHT]));

% Constraints on values
constraint forall(i in HEIGHT, j in WIDTH) (
  garden[i, j] >= 0);
constraint forall(j in WIDTH) (
  sum([garden[i,j] | i in HEIGHT]) = colinsects[j]);
constraint forall(i in HEIGHT) (
  sum([garden[i,j] | j in WIDTH]) = rowinsects[i]);
  
% Known positions
constraint forall(i in HEIGHT, j in WIDTH) (
  if knownpositions[i,j] != 0 then garden[i,j] = knownpositions[i,j] endif);

solve satisfy;

output [ show(garden[i,j]) ++ 
         if j == c then "\n" else "\t" endif |
         i in HEIGHT, j in WIDTH
];
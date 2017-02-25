function Iedg = hyst_thresh(I, trhH, trhL)
%% Select as true edges all regions above lower threshold that are connected
% to points above bigger threshold

bigger_trhL = I > trhL; % Determine edges above lower threshold
% Determine points abover bigger threshold
[bigger_trhH_r, bigger_trhL_c] = find(I > trhH);  
% Select true edges
Iedg = bwselect(bigger_trhL, bigger_trhL_c, bigger_trhH_r, 8);

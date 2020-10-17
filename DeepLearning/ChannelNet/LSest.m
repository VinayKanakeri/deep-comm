function H_est = LSest(Y,X)
temp_y = Y;
temp_y(:,[2:7]) = 0;
temp_y(:,[9:end]) = 0;
H_est = temp_y./X;
end



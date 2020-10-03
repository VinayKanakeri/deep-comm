function H = LSE(Y,Xp,Np)
H = zeros(size(Y));
for i=1:Np
    H(:,i+(i-1)*5) = Y(:,i+(i-1)*5)./ Xp ;
end
end
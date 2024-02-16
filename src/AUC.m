function A = AUC(pfp,ptp)
% Compute the AUC


x = [0;pfp(:);1];
y = [0;ptp(:);1];

A = trapz(x,y);

end


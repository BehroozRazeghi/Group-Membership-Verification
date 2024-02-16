function XX = PosNeg(X,signn)    

XX =  signn*X;
XX(XX<=0) = 0;

end
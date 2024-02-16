function X = UnitNorm(X)

nx = sqrt(sum(X.^2));
X = bsxfun(@times,X,1./nx);

end
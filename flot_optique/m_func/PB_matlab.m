function [Zl] = PB_matlab( Z )
% Projection sur l'ensemble B.
% Justifie par la theorie.

R= sqrt(sum(Z.^2, 3));

R= repmat(R, [1,1,size(Z,3)]);
Zl= Z ./ max(1, R);
Zl(isnan(Zl))=0;

end


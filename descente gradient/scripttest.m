% A=[1 0 0;0 1 0;0 0 1];
% b=[2;0;-1];
% u=degrad(A,b,b);
% u2=degrad(A,b,[1;1;1]);
% A2=[1 1 1;0 1 1;0 0 1];
% A3=[1 -1 0;0 1 -1;0 0 1];
% u3=degrad(A2,b,[1; 1; 1]);
% u4=A3*b;
% u3-u4;
% u5=degrad(A2,b,A3*b);
% u5-u4;
% A4=[1 0 0; 1 1 0; 0 0 1];
% u6=degrad(A4,b,A4\b);
% A5=[1 0.45 0.55; 0 1 0; 0.75 0.25 1];
% b2=[0; 5; 0];
% u7=degrad(A5,b2,[1; 1; 1])
% A=[1 0 0 0 0 0 0 0 0; -0.1 1 -0.5 -0.1 -0.1 -0.2 0 0 0;
%     0 -0.5 1 0 -0.2 -0.3 0 0 0; -0.1 -0.1 0 1 -0.5 0 -0.2 -0.1 0;
%     -0.1 -0.1 -0.1 -0.3 1 -0.1 -0.1 -0.1 -0.1; 0 -0.1 -0.1 0 -0.2 1 0 -03 -0.3;
%     0 0 0 -0.3 -0.5 0 1 -0.2 0; 0 0 0 -0.2 -0.2 -0.2 -0.1 1 -0.3;
%     0 0 0 0 0 0 0 0 1];
% cond(A)
% b=[5;0;0;0;0;0;0;0;1];
% u=degrad(A,b,b)
A=[1 0 0 0; -0.5 1 -0.2 -0.3; 0 0 1 0; -0.2 -0.1 -0.7 1];
cond(A)
b=[1; 0; 5; 0];
u=degrad(A,b,b)
function output = OF_TVL1(ddp, varargin )
% datas doit contenir ISOurce, ITarget, lambda et beta.

p = inputParser;
addRequired(p,'ddp');
parse(p,ddp);
addOptional(p,'init',zeros(size(ddp.IS, 1), size(ddp.IS, 2), 2));
parse(p,ddp,varargin{:});
init = p.Results.init;
v0=single(init);

%%

% input
ISource = ddp.IS;
ITarget = ddp.IT;
lambda = ddp.lambda;%single(0.05);
beta = ddp.beta;%single(0.0001);

% Initialisation. 
U = cat(3, zeros(size(ITarget), 'single'), v0);

% Recalage de ISource pour considérer que le déplacement est petit. 
Itarget_recaled = registre(ISource, v0, 'linear');

% Gradient temporel.
It = Itarget_recaled - ITarget ;

% Gradient spatial. 
GI = gradient_diff_centree(Itarget_recaled);

% Précalcul des valeurs utiles. 
A= cat(3, beta*ones(size(ITarget)), GI);
NA = sum(A.^2, 3);

% ****************a régler****************

sigma= single(0.1);
tau= single(0.5 / (24 * sigma));

ITT = 2000;
% run

Z= single(gradient_mex_single(single(U)));

U_bar = U;


residu0 = length(U(:)) ;
residu = residu0; 
c=0;

Precalcul_rho = -sum(GI.*v0, 3) + It;

while residu / residu0 > 1e-6 && c < ITT
    
    tilde_Z = Z + sigma *  gradient_mex_single(U_bar);
    Z(:,:,1:2) = PB_matlab(tilde_Z(:,:,1:2));
    Z(:,:,3:6) = PB_matlab(tilde_Z(:,:,3:6));
        
    U_ans=U;
    
    tilde_U = U + tau * divergence_mex_single(Z) ;
    rho = Precalcul_rho + sum(GI.*tilde_U(:,:,2:3), 3) ...
                        + beta * tilde_U(:,:,1) ;
    Rrho = repmat(rho, 1,1,3);
    U = tilde_U +...
        ( tau*lambda*A).*repmat((rho < -tau*lambda*NA), 1, 1, 3) + ...
        (-tau*lambda*A).*repmat((rho >  tau*lambda*NA), 1, 1, 3) + ...
        (-Rrho.* A ./repmat(NA,1,1,3)).*repmat((abs(rho) <= tau*lambda*NA), 1, 1, 3);
    
    theta = 1 / sqrt(1+2*tau*(lambda/2));
    tau = theta*tau; sigma = sigma / theta;
    
    U_bar = U + theta * (U - U_ans);
    
    residu = sum((U(:)-U_ans(:)).^2) ;
    c=c+1;
    
end

output =  U(:,:,2:3); 

end


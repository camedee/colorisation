function output = OF_LK(ddp, varargin )
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

% Recalage de ISource pour considérer que le déplacement est petit. 
Itarget_recaled = registre(ISource, v0, 'linear');

% Gradient temporel.
It = Itarget_recaled - ITarget ;

% Gradient spatial. 
GI = gradient_diff_centree(Itarget_recaled);

G= cat(3, GI, It);

% calcul lucas kanade
U = lk_mex(single(G));

output = v0+U ;

end


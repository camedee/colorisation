function carte = flow2carte( flow )

[x_max, y_max,~]= size(flow);

[X,Y]= meshgrid(1:y_max, 1:x_max);

F1 = max( min( flow(:,:,1) + Y, x_max), 1);
F2 = max( min( flow(:,:,2) + X, y_max), 1);

carte = sub2ind([x_max, y_max], floor(F1), floor(F2) );

end


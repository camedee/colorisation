function [] = lucasKanaderation(image1,image2)
%Détermine le flow optique entre deux images suivant Lukas Kanade.
%Utilisation de l'algorithme porposé par Zhiyuan.
    %to double and to gray
    im1t = im2double(rgb2gray(image1));
    im2t = im2double(rgb2gray(image2));
    % downsize to half
    im1 = imresize(im1t, 0.5);
    im2 = imresize(im2t, 0.5);
    
    
%     subplot(2,1,1)
%     imshow(im1)
%     subplot(2,1,2)
%     imshow(im2)

    ww = 45;
    w = round(ww/2);

    % Lucas Kanade Here
    % for each point, calculate I_x, I_y, I_t
    Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); % partial on x
    Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); % partial on y
    It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t
    u = zeros(size(im1));
    v = zeros(size(im2));

    % within window ww * ww
    for i = w+1:size(Ix_m,1)-w
       for j = w+1:size(Ix_m,2)-w
          Ix = Ix_m(i-w:i+w, j-w:j+w);
          Iy = Iy_m(i-w:i+w, j-w:j+w);
          It = It_m(i-w:i+w, j-w:j+w);

          Ix = Ix(:);
          Iy = Iy(:);
          b = -It(:); % get b here

          A = [Ix Iy]; % get A here
          nu = pinv(A)*b; % get velocity here

          u(i,j)=nu(1);
          v(i,j)=nu(2);
       end;
    end;

    % downsize u and v
    u_deci = u(1:10:end, 1:10:end);
    v_deci = v(1:10:end, 1:10:end);
    
    % get coordinate for u and v in the original frame
    [m, n] = size(im1t);
    [X,Y] = meshgrid(1:n, 1:m);
    X_deci = X(1:20:end, 1:20:end);
    Y_deci = Y(1:20:end, 1:20:end);
    
    figure();
    subplot(3,1,1)
    imshow(image1)
    subplot(3,1,2)
    imshow(image2)
    subplot(3,1,3)
    imshow(image2)
    hold on;
    % draw the velocity vectors
    quiver(X_deci, Y_deci, u_deci,v_deci, 'y')
end


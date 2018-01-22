function G = gradient_diff_centree( U )

G = zeros(size(U,1), size(U,2), 2, 'like', U);
G(2:end-1,:,1) = (U(3:end, :) - U(1:end-2, :))/2;
G(:,2:end-1,2) = (U(:, 3:end) - U(:, 1:end-2))/2;

end


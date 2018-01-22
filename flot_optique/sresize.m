function data_out = sresize( data_in,  fact)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

data_out.IS = imresize(data_in.IS, 1/fact);
data_out.IT = imresize(data_in.IT, 1/fact);
data_out.lambda = data_in.lambda;
data_out.beta = data_in.beta;

end


function d_b = matchscale(d_a, d_b)
% MATCHSCALE Scale the magnitude of the detail coefficients of each subband of B so that the subband energy (the summed squared magnitude of all subband coefficients) is equal to the corresponding energy of the A subbands. If the original energy is EA and the desired energy is EB then the correct scaling factor is sqrt(Ea)/sqrt(Eb). Leave the coarsest scale coefficients (approximation subband) unchanged.

for i = 1:size(d_a, 4)
    se_a = sum(abs(d_a(:, :, :, i)).^2, 'all');
    se_b = sum(abs(d_b(:, :, :, i)).^2, 'all');
    scale = sqrt(se_a)/sqrt(se_b);
    d_b(:, :, :, i) = d_b(:, :, :, i) .* scale;
end
end
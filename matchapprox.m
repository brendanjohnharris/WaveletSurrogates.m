function a_b = matchapprox(a_a, a_b)
    for i = 1:size(a_a, 3)
        se_a = sum(abs(a_a(:, :, i)).^2, 'all');
        se_b = sum(abs(a_b(:, :, i)).^2, 'all');
        scale = sqrt(se_a)/sqrt(se_b);
        a_b(:, :, i) = a_b(:, :, i) .* scale;
    end
end
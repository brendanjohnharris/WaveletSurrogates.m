function a_b = matchapprox(a_a, a_b)
    se_a = sum(abs(a_a).^2, 'all');
    se_b = sum(abs(a_b).^2, 'all');
    scale = sqrt(se_a)/sqrt(se_b);
    a_b = a_b .* scale;
end
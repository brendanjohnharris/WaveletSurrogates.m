function loss = approxcriterion(a_a, a_b)
    se_a = sum(abs(a_a).^2, [1, 2]); % Approximation subband
    se_b = sum(abs(a_b).^2, [1, 2]);
    loss = sqrt(mean((se_a - se_b).^2, 'all'));
end

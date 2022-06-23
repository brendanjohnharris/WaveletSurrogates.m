function loss = approxcriterion(a_a, a_b)
    se_a = sum(abs(a_a).^2, 'all'); % Approximation subband
    se_b = sum(abs(a_b).^2, 'all');
    loss = sqrt((se_a - se_b).^2);
end

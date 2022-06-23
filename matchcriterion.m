function loss = matchcriterion(d_a, d_b)
    se_a = cellfun(@(x) squeeze(sum(abs(x).^2, [1, 2, 3])), d_a, 'un', 0); % Sum of energy in each subband
    se_b = cellfun(@(x) squeeze(sum(abs(x).^2, [1, 2, 3])), d_b, 'un', 0);
    se_a = horzcat(se_a{:});
    se_b = horzcat(se_b{:});
    loss = sqrt(sum((se_a - se_b).^2, 'all'));
end

function loss = matchcriterion(d_a, d_b)
    se_a = cellfun(@(x) mean(abs(x).^2, 'all'), d_a);
    se_b = cellfun(@(x) mean(abs(x).^2, 'all'), d_b);
    loss = mean(abs(se_a - se_b));
end
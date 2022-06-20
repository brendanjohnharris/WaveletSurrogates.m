function B = wavesurr3(X, options)
% WAVESURR3 Surrogate data for a two-dimensional time series via the wavelet transform
% https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0048766#s4

arguments
    X (:,:,:) {mustBeNumeric}
    options.tol (1, 1) {mustBeNumeric} = 0.001
    options.maxiter (1, 1) {mustBeNumeric} = 100
end

if mod(size(X, 1), 2); X = X(1:end-1, :, :); end
if mod(size(X, 2), 2); X = X(:, 1:end-1, :); end
if mod(size(X, 2), 2); X = X(:, :, 1:end-1); end
mu = mean(X, 'all', 'omitnan');
sigma = std(X, 0, 'all', 'omitnan');
nanidxs = isnan(X);
X(nanidxs) = 0;


% Center and normalize the reference image A.
A = (X - mu)./sigma;

% Generate a normal white noise B of mean 0 and variance 1 of the same size as A;
B = randn(size(A));
B(nanidxs) = 0; % OK?

% Use the DT-CWT with symmetric extension (we choose half-point) to generate the multi-scale and multi-orientation decompositions of both A and B. We chose the (13,19)-tap near-orthogonal filters at scale 1 and the 14-tap Q-Shift filters at scales ≥2 because it is a good compromise between computational complexity and aliasing energy [50].
[a_a,d_a] = dualtree3(A, 'FilterLength', 14, 'LevelOneFilter', 'nearsym13_19');
[a_b,d_b] = dualtree3(B, 'FilterLength', 14, 'LevelOneFilter', 'nearsym13_19');
i = 1;
fprintf("Iteration %d: loss = %f\n", i, matchcriterion(d_a, d_b))
loss = Inf;
loss_i = matchcriterion(d_a, d_b);
while loss_i < loss && i < options.maxiter && loss_i > options.tol
    loss = loss_i;
    % Scale the magnitude of the detail coefficients of each subband of B
    d_b = arrayfun(@(i) matchscale(d_a{i}, d_b{i}), 1:length(d_a), 'un', 0);
    % Transform the scaled coefficients of B back into the spatial domain.
    B = idualtree3(a_b, d_b, 'FilterLength', 14, 'LevelOneFilter', 'nearsym13_19');
    i = i + 1;
    [a_b,d_b] = dualtree3(B, 'FilterLength', 14, 'LevelOneFilter', 'nearsym13_19');
    loss_i = matchcriterion(d_a, d_b);
    fprintf("Iteration %d: loss = %f\n", i, loss_i)
end
B(nanidxs) = NaN;
B = B.*sigma + mu;
end
    
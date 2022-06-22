function B = wavesurr3(X, options)
% WAVESURR3 Surrogate data for a two-dimensional time series via the wavelet transform
% https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0048766#s4

arguments
    X (:,:,:) {mustBeNumeric}
    options.tol (1, 1) {mustBeNumeric} = 1e-3
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
E = sum(abs(A).^2, 'all'); % The total energy of the signal. Used to nromalize the loss. Assumes equal energy contribution over spatial and temporal dimensions.

% Generate a normal white noise B of mean 0 and variance 1 of the same size as A;
B = randn(size(A));
B(nanidxs) = 0; % OK?

% Use the DT-CWT with symmetric extension (we choose half-point) to generate the multi-scale and multi-orientation decompositions of both A and B. We chose the (13,19)-tap near-orthogonal filters at scale 1 and the 14-tap Q-Shift filters at scales ≥2 because it is a good compromise between computational complexity and aliasing energy [50].
forward = @(x) dualtree3(x, 'FilterLength', 18, 'LevelOneFilter', 'nearsym13_19');
inverse = @(x, y) idualtree3(x, y, 'FilterLength', 18, 'LevelOneFilter', 'nearsym13_19');

[a_a,d_a] = forward(A);
[a_b,d_b] = forward(B);
i = 1;
loss = Inf;
loss_i = matchcriterion(d_a, d_b)./E;
loss_a = approxcriterion(a_a, a_b)./E;
fprintf("Iteration %d: approx. loss = %.3d, detail loss = %.3d\n", i-1, loss_a, loss_i)
while i < options.maxiter && (loss_i > options.tol || loss_a > options.tol)
    loss(end+1) = loss_i;

    % Scale the magnitude of the detail coefficients of each subband of B
    d_b = arrayfun(@(i) matchscale(d_a{i}, d_b{i}), 1:length(d_a), 'un', 0); % Match detail
    a_b = matchapprox(a_a, a_b); % Match approximation

    % Transform the scaled coefficients of B back into the spatial domain.
    B = inverse(a_b, d_b);
    [a_b,d_b] = forward(B);
    loss_i = matchcriterion(d_a, d_b)./E;
    loss_a = approxcriterion(a_a, a_b)./E;

    fprintf("Iteration %d: approx. loss = %.3d, detail loss = %.3d\n", i, loss_a, loss_i)
    i = i + 1;
end
B(nanidxs) = NaN;
B = B.*sigma + mu;
end
    
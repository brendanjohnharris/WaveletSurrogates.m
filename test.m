clear all
X = load("testData.mat").sigBPass;
X = X(51:150, 101:200, :);

S = wavesurr3(X, maxiter=25, tol=1e-3);

imagesc(X(:, :, 25))
figure; imagesc(S(:, :, 25))

hold on
for i = 1:size(S, 3)
    imagesc(S(:, :, i))
    pause(0.1);
end

periodogram = @(x) abs(fft(x)).^2;


p = periodogram(X(1, 1, :));
P = zeros(size(X, 1), size(X, 2), length(p));
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        P(i, j, :) = periodogram(X(i, j, :));
    end
end
p = squeeze(nanmean(P, [1, 2]))
loglog(p)
hold on

P = zeros(size(X, 1), size(X, 2), length(p));
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        P(i, j, :) = periodogram(S(i, j, :));
    end
end
p = squeeze(nanmean(P, [1, 2]))
loglog(p)



[a_a, d_a] = dualtree3(X)
[a_b, d_b] = dualtree3(S)

abs(d_a{1})./abs(d_b{1})
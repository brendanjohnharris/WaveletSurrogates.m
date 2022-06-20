X = load("testData.mat").sigBPass;
X = X - mean(X, 3);

X = X(:, :, 1:10);

S = wavesurr3(X, maxiter=100);

imagesc(X(:, :, 1))
imagesc(S(:, :, 1))
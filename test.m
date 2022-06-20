clear all
X = load("testData.mat").sigBPass;
X = X - mean(X, 3);

X = X(:, :, 1:100);

S = wavesurr3(X, maxiter=500);

imagesc(X(:, :, 50))
figure; imagesc(S(:, :, 50))
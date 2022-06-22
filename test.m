clear all
X = load("testData.mat").sigBPass;

S = wavesurr3(X, maxiter=200, tol=1e-4);

imagesc(X(:, :, 25))
figure; imagesc(S(:, :, 25))

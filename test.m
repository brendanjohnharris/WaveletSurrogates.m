X = load("testData.mat").sigBPass;
X = X(:, :, 1:50);

Y = wavesurr3(X)
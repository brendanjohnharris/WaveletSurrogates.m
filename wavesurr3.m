function wavesurr3(X)
% WAVESURR3 Surrogate data for a two-dimensional time series via the wavelet transform

arguments
    X (:,:,:) {mustBeNumeric}
end

if mod(size(X, 1), 2); X = X(1:end-1, :, :); end
if mod(size(X, 2), 2); X = X(:, 1:end-1, :); end
if mod(size(X, 2), 2); X = X(:, :, 1:end-1); end
mu = mean(X, 'all', 'omitnan');
sigma = std(X, 0, 'all', 'omitnan');
X = X - mu;
nanidxs = isnan(X);
X(nanidxs) = 0; % ! Will have to check the validity of this. Should be fine, since wavelet method won't 'mix in the edge' like the Fourier approach, since it is designed from non-stationarity. At least for the small wavelets; might be a problem for the very largest wavelets though, but those are spatially filtered anyway...

% 1. generate a Gaussian white noise time series to match the original data length
X_ = randn(size(X));

% 2. derive the wavelet transform of this noise to extract the phase φ(t,f)
[a_,d_] = dualtree3(X_);

% 3. combine this randomised phase and the WT modulus of the original signal to obtain a surrogate time-frequency distribution
[a, d] = dualtree3(X); % Leave the a's untouched
d = arrayfun(@(x) abs(d{x}).*exp(angle(d_{x})*1i), 1:length(d_), 'un', 0);

% 4. a nonstationary surrogate time series x^(t) is reconstructed by taking the real part of the inverse wavelet transform of Wx^(t,f)
X_ = idualtree3(a, d);
X_ = sigma.*X_./std(X_, 0, 'all', 'omitnan');

% 5. rescale the surrogate x^(t) to the distribution of the original time series by sorting the data (after a wavelet filtering in the frequency band of interest) according to the ranking of values of the wavelet-based surrogate11,
% ! Won't do this for now, since sorting data over multiple dimensions is not clear.

X_ = X_ + mu;
X_(nanidxs) = NaN

end
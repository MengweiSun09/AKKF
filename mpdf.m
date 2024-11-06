function y = mpdf(X, Mu, Sigma,P0)
X0 = X - Mu;


[n,d] = size(X0);
xRinv = zeros(n,d,'like',internal.stats.dominantType(X0,Sigma));
logSqrtDetSigma = zeros(n,1,'like',Sigma);
[R,err] = cholcov(Sigma,0);

if isempty(R) == 1
    Sigma = P0;
end
[R,err] = cholcov(Sigma,0);

% if err ~= 0
%     error(message('stats:mvnpdf:BadMatrixSigma'));
% end
X0 = X0';
d = size(X0,2);
% Create array of standardized data, and compute log(sqrt(det(Sigma)))
xRinv = X0 / R;


logSqrtDetSigma = sum(log(diag(R)));
quadform = sum(xRinv.^2, 2);
y = exp(-0.5*quadform - logSqrtDetSigma - d*log(2*pi)/2);
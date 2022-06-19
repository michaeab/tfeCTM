function [params,paramsLb,paramsUb] = defaultParams(obj,varargin)
% [params,paramsLb,paramsUb] = defaultParams(obj,varargin)
%
% Set objects params to default values as well as provide reasonable lower
% and upper bournds.
%
% All three returns are in struct array form, use paramsToVec on the structs to
% get vector form.
%
% Optional key/value pairs
%    'defaultParams'     - (struct, default empty). If not empty, take the
%                          passed structure array as defining the default
%                          parameters.

% History:
%   04/15/22  mab          Wrote it.

%% Parse vargin for options passed here
p = inputParser; p.KeepUnmatched = true;
p.addParameter('defaultParams',[],@(x)(isempty(x) | isstruct(x)));
p.parse(varargin{:});

if (isempty(p.Results.defaultParams))
    % Set up structure
    params = obj.tfeIndivInitParams;
    
else
    params = p.Results.defaultParams;
end

%% Set up search bounds
lambdaLowBound = 0; lambdaHighBound = 5;
expLowBound = 0.005; expHighBound = 10;



% Pack bounds into vector form of parameters.
for ii = 1:obj.nDirections
    paramsLb(ii).lambda = lambdaLowBound;
    paramsLb(ii).exponent = expLowBound;
end
for ii = 1:obj.nDirections
    paramsUb(ii).lambda = lambdaHighBound;
    paramsUb(ii).exponent = expHighBound;
end

end
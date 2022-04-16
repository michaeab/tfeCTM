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
ampLowBound = 0; ampHighBound = 5;
minLagLowBound = 0.01; minLagHighBound = 10;
scaleLowBound = 0.01; scaleHighBound = 3;


% Pack bounds into vector form of parameters.
for ii = 1:obj.nDirections
    paramsLb(ii).amplitude = ampLowBound;
    paramsLb(ii).minLag = minLagLowBound;
    paramsLb(ii).scale = scaleLowBound;
end
for ii = 1:obj.nDirections
    paramsUb(ii).amplitude = ampHighBound;
    paramsUb(ii).minLag = minLagHighBound;
    paramsUb(ii).scale = scaleHighBound;
end

end
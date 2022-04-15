function [params,paramsLb,paramsUb] = defaultParams(obj,varargin)
% [params,paramsLb,paramsUb] = defaultParams(obj,varargin)
%
% Set objects params to default values as well as provide reasonable lower
% and upper bournds.
%
% All three returns are in struct form, use paramsToVec on the structs to
% get vector form.
%
% Optional key/value pairs
%    'defaultParams'     - (struct, default empty). If not empty, take the
%                          passed structure as defining the default
%                          parameters.
%
% History:
%   11/11/21    mab        changed over for the CTM params


% Parse vargin for options passed here
p = inputParser; p.KeepUnmatched = true;
p.addParameter('defaultParams',[],@(x)(isempty(x) | isstruct(x)));
p.parse(varargin{:});

if (isempty(p.Results.defaultParams))
    %% Default parameters for linear mechanisms
    %
    % This is dimension specific
    switch obj.numMechanism
        case 1
            params.angle = 75;
            params.minAxisRatio = 0;
            params.scale = 1;
        case 2
            params.angle = 75;
            params.minAxisRatio = 0.03;
            params.scale = 1;
    end
    
    %% The exponential function
    params.amplitude = 0.4;
    params.minLag    = 0.15;
    
else
    params = p.Results.defaultParams;
end

switch obj.numMechanism
    case 1
        paramsLb.angle = -90;
        paramsLb.minAxisRatio =0;
        paramsLb.scale = 0;

        paramsUb.angle = 90;
        paramsUb.minAxisRatio = 0;
        paramsUb.scale = 100;
    case 2
        paramsLb.angle = -90;
        paramsLb.minAxisRatio = 0.0001;
        paramsLb.scale = 0;

        paramsUb.angle = 90;
        paramsUb.minAxisRatio = 1;
        paramsUb.scale = 100;

end

%% Lower bounds
paramsLb.amplitude = 0.0001;
paramsLb.minLag    = 0.15;


%% Upper bounds
paramsUb.amplitude = 100;
paramsUb.minLag    = 1;


end
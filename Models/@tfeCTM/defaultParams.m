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
            params.weightL   = 75;
            params.weightS   = 02;
            
            
            
        case 2
            params.weightL_1 = 5;
            params.weightS_1 = 5;
            params.weight_M2 = 0.5;
    end
    
    %% The exponential function
    params.amplitude = 0.4;
    params.minLag    = 0.35;
    
else
    params = p.Results.defaultParams;
end

switch obj.numMechanism
    case 1
        paramsLb.weightL   = -100;
        paramsLb.weightS   = -100;
        
        paramsUb.weightL  = 100;
        paramsUb.weightS  = 100;
    case 2
        paramsLb.weightL_1 = 0;
        paramsLb.weightS_1 = -100;
        paramsLb.weight_M2 = 0.0000001;

        paramsUb.weightL_1 = 100;
        paramsUb.weightS_1 = 100;
        paramsUb.weight_M2 = 0.9999999;

end

%% Lower bounds
paramsLb.amplitude = 0.0;
paramsLb.minLag    = 0.15;


%% Upper bounds
paramsUb.amplitude = 10;
paramsUb.minLag    = 1;


end
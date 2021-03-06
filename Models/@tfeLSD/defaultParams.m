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
            
        case 2
            params.angle = 90;
            params.minAxisRatio = 0.1;
           
    end
    
    %% The exponential function
    params.lambda    = .1;
    params.exponent  = 2;
    
else
    params = p.Results.defaultParams;
end

switch obj.numMechanism
    case 1
        paramsLb.angle = -90;
        paramsLb.minAxisRatio =0;
        
        paramsUb.angle = 90;
        paramsUb.minAxisRatio = 0;
       
    case 2
        paramsLb.angle = -90;
        paramsLb.minAxisRatio = 0.00001;
       

        paramsUb.angle = 90;
        paramsUb.minAxisRatio = 1;
        
end

%% Lower bounds
paramsLb.lambda    = 0.00001;
paramsLb.exponent  = 0.00001;


%% Upper bounds
paramsUb.lambda      = 50;
paramsUb.exponent    = 50;


end
function x = paramsToVec(obj,params,varargin)
% x = paramsToVec(obj,params,varargin)
%
% Convert vector form of parameters to struct
%
% Key/value pairs
%   'UseNoiseParam' - true/false (default false).  Use the noise parameter?

% Parse input.
p = inputParser;
p.addRequired('params',@isstruct);
p.addParameter('UseNoiseParam',false,@islogical);
p.parse(params,varargin{:});
params = p.Results.params;

switch obj.numMechanism
    case 1
        % Take the parameter structure into a vector
        
        x(1) = params.angle;
        x(2) = params.minAxisRatio;
        x(3) = params.lambda;
        x(4) = params.exponent;
        
    case 2
        x(1) = params.angle;
        x(2) = params.minAxisRatio;
        x(3) = params.lambda;
        x(4) = params.exponent;
       

end

% transpose to match convention
x = x';

end
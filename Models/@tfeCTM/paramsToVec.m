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
        
        x(1) = params.weightL;
        x(2) = params.weightS;
        x(3) = params.minLag;
        x(4) = params.amplitude;
        
        
        
        % Optional inclusion of noise
        if (p.Results.UseNoiseParam)
            x(5) = params.noiseSd;
        end
    case 2
        x(1) = params.weightL_1;
        x(2) = params.weightS_1;
        x(3) = params.weight_M2;
        x(4) = params.minLag;
        x(5) = params.amplitude;
        
        % Optional inclusion of noise
        if (p.Results.UseNoiseParam)
            x(6) = params.noiseSd;
        end
end

% transpose to match convention
x = x';

end
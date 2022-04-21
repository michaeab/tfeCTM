function params = vecToParams(obj,x,varargin)
% params = vecToParams(obj,x,varargin)
%
% Convert vector form of parameters to struct
%
% Key/value pairs
%   'UseNoiseParam' - true/false (default false).  Use the noise parameter?

% Parse input. At the moment this does type checking on the params input
% and has an optional key value pair that does nothing, but is here for us
% as a template.
p = inputParser;
p.addRequired('x',@isnumeric);
p.addParameter('UseNoiseParam',false,@islogical);
p.parse(x,varargin{:});
x = p.Results.x;

switch obj.numMechanism
    case 1
        params.angle        = x(1);
        params.minAxisRatio = x(2);
        params.lambda       = x(3);
        params.exponent     = x(4);
        params.scale        = x(5);
    case 2
        params.angle        = x(1);
        params.minAxisRatio = x(2);
        params.lambda       = x(3);
        params.exponent     = x(4);
        params.scale        = x(5);
end

end
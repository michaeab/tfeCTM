function paramPrint(obj,params,varargin)
% paramPrint(obj,params,varargin)
%
% Print out useful things about parameters to the command window
%
% Key/value pairs
%   'PrintType' - string (default 'standard').  What to print.
%     'standard' - Standard print of parameters.

% Parse input. At the moment this does type checking on the params input
% and has an optional key value pair that does nothing, but is here for us
% as a template.
p = inputParser;
p.addRequired('params',@isstruct);
p.addParameter('PrintType','standard',@ischar);
p.parse(params,varargin{:});
params = p.Results.params;

% Quadratic parameters
switch (p.Results.PrintType)
    case 'standard'
        switch obj.dimension
            case 2
                fprintf('Mechanism Angle: %0.2f, MAR: %0.2f\n',params.angle,params.minAxisRatio);
            case 3
                fprintf('UNKNOWN PARAMS: the number of params passed is not yet set up' );
                %                 if length(fieldnames(params)) ==4
                %                     fprintf('Mechanism Weights: M1 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL,params.weightM, params.weightS);
                %                 elseif length(fieldnames(params)) == 5
                %                     fprintf('Mechanism Weights: M1 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL,params.weightM, params.weightS);
                %                     fprintf('Mechanism Weights: M2-- Scaling Value: %0.2f\n',params.weight_M2);
                %                 elseif length(fieldnames(params)) == 6
                %                     fprintf('Mechanism Weights: M1 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL_1,params.weightM_1, params.weightS_1);
                %                     fprintf('Mechanism Weights: M2 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL_2,params.weightM_2, params.weightS_2);
                %                 else
                %                     fprintf('UNKNOWN PARAMS: the number of params passed is not yet set up' );
                %                 end
        end
        fprintf('Nonlinearity Params: lambda = %0.2f, exponent = %0.2f\n',params.lambda,params.exponent);
        fprintf('\n');
    otherwise
        error('Unknown parameter print type passed')

end



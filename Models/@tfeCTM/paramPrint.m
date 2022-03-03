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
                if length(fieldnames(params)) == 4
                    fprintf('Mechanism Weights: M1 -- L %0.2f, S %0.2f\n',params.weightL,params.weightS);
                elseif length(fieldnames(params)) == 5
                    fprintf('Mechanism Weights: M1 -- L %0.2f, S %0.2f\n',params.weightL_1,params.weightS_1);
                    fprintf('Mechanism Weights: M2 -- L %0.2f, S %0.2f\n',params.weightL_2,params.weightS_2);
                else
                    fprintf('UNKNOWN PARAMS: the number of params passed is not yet set up' );
                end
            case 3
                if length(fieldnames(params)) ==4
                    fprintf('Mechanism Weights: M1 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL,params.weightM, params.weightS);
                elseif length(fieldnames(params)) == 5
                    fprintf('Mechanism Weights: M1 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL_1,params.weightM_1, params.weightS_1);
                    fprintf('Mechanism Weights: M2 -- L %0.2f, M %0.2f, S %0.2f\n',params.weightL_2,params.weightM_2, params.weightS_2);
                else
                    fprintf('UNKNOWN PARAMS: the number of params passed is not yet set up' );
                end
        end
        fprintf('Exponential Params: Amplitude = %0.2f,Min Lag = %0.2f\n',params.amplitude,params.minLag);
        fprintf('\n');
    otherwise
        error('Unknown parameter print type passed')
        
end



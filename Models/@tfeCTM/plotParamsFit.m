function [figHndl] = plotParamsFit(packet,params,)
% [paramsFit,fVal,modelResponseStruct] = fitResponse(obj,thePacket,varargin)
%
% Syntax:
%  [paramsFit,fVal,modelResponseStruct] = obj.fitResponse(thePacket)
%
% Description:
%   Fit method for the tfe class.  This is meant to be model independent,
%   so that we only have to write it once.
%
% Inputs:
%   thePacket             - Structure. A valid packet
%
% Optional key/value pairs
%  'defaultParamsInfo'    - Struct (default empty).  This is passed to the
%                           defaultParams method. This can be used to do
%                           custom things for the search routine. [We might
%                           try to make this go away.]
%  'defaultParams'        - Struct (default empty). Params values for
%                           defaultParams to return. In turn determines
%                           starting value for search, unless overridden by
%                           a non-empty initialParams key/value pair. [We
%                           might try to make this go away, and use the
%                           initialParams key/value pair below, which is
%                           simpler to read and think about.]
%  'intialParams'         - Struct (default empty). Params structure
%                           containing initial parameters for search. If empty,
%                           what's returned by the defaultParams method is
%                           used. This key/value pair overrides the
%                           defaultParams key/value pair, which in turn
%                           overrides what is returned by the
%                           defaultParams method.
%  'vlbParams'            - Struct (default empty). Params structure
%                           containing lower bounds for search. If empty,
%                           what's returned by the defaultParams method is
%                           used.
%  'vubParams'            - Struct (default empty). Params structure
%                           containing upper bounds for search. If empty,
%                           what's returned by the defaultParams method is
%                           used.
%  'A'                     - Matrix (default empty). Linear inequality
%                           constraint matrix.
%  'b'                    - Vector (default empty). Linear inequality
%                           constraint vector.
%  'Aeq'                  - Matrix (default empty). Linear equality
%                           constraint matrix.
%  'beq'                  - Vector (default empty). Linear equality
%                           constraint vector.
%  'nlcon'                - Handle to nonlinear constraint function
%                           (default empty)
%  'searchMethod          - String (default 'fmincon').  Specify search
%                           method:
%                              'fmincon' - Use fmincon
%                              'linearRegression' - Rapid estimation of
%                                   simplified models with only an
%                                   amplitude parameter. Parameter bounds
%                                   and constraints do not apply. Nor does
%                                   errorType or errorWeightVector.
%  'DiffMinChange'        - Double (default empty). If not empty, changes
%                           the default value of this in the fmincon
%                           optionset.
%  'fminconAlgorithm'     - String (default 'active-set'). If set to a string,
%                           passed on as algorithm in options to fmincon.
%                           Can be empty or any algorithm string understood
%                           by fmincon.
%                              [] - Use fmincon's current default algorithm
%                              'active-set' - Active set algorithm
%                              'interior-point' - Interior point algorithm.
%  'errorType'            - String (default 'rmse'). Determines what error
%                           is minimized, passed along as an option to the
%                           fitError method.
%  'errorWeightVector'    - Vector of weights to use on error for each
%                           response value. Only valid if error type is
%                           'rmse'. Passed along as an option to the
%                           fitError method.
%  'fitErrorScalar'       - Computed fit error is multiplied by this before
%                           return.  Sometimes getting the objective
%                           function onto the right scale makes all the
%                           difference in fitting. Passed along as an
%                           option to the fitError method.
%  'maxIter'              - If not empty, use this as the maximum number of
%                           interations in the search.
%  'maxFunEval'           - If not empty, use this as the maximum number of
%                           function evaluations in the search.
%
% Outputs:
%   paramsFit             - Structure. Fit parameters.
%   fVal                  - Scalar. Fit error
%   predictedResponse     - Structure. Response predicted from fit.

% History:
%  11/26/18  dhb       Added comments about key/value pairs that were not
%                      previously commented.

p = inputParser; p.KeepUnmatched = true; p.PartialMatching = false;
p.addRequired('thePacket',@isstruct);
p.addParameter('defaultParamsInfo',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('defaultParams',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('initialParams',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('vlbParams',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('vubParams',[],@(x)(isempty(x) | isstruct(x)));
p.addParameter('A',[],@isnumeric);
p.addParameter('b',[],@isnumeric);
p.addParameter('Aeq',[],@isnumeric);
p.addParameter('beq',[],@isnumeric);
p.addParameter('nlcon',[]);
p.addParameter('maxIter',[],@isnumeric);
p.addParameter('maxFunEval',[],@isnumeric);
p.addParameter('searchMethod','fmincon',@ischar);
p.addParameter('DiffMinChange',[],@isnumeric);
p.addParameter('fminconAlgorithm','active-set',@(x) (isempty(x) | ischar(x)));
p.parse(thePacket,varargin{:});
% Set the colors
plotColors = [230 172  178; ...
    194  171  253; ...
    36   210  201; ...
    32   140  163; ...
    253  182   44; ...
    252  153  233; ...
    235   64   52; ...
    255  118  109; ...
    121   12  126; ...
    179  107  183; ...
    185  177   91; ...
    225  218  145;...
    ]'./255;

% Get the l2 norm of the cone contrasts
vecContrast = sqrt(cL.^2+cS.^2);
matrixContrasts = reshape(vecContrast,size(lags));


legendLocation = 'northeast';

% sub plot 1 - mechanism outputs
tcHndl1 = figure;
subplot(1,3,1); hold on
plotNames.title  = 'M1 and M2 Outputs';
plotNames.xlabel = 'Stimuli';
plotNames.ylabel = 'Mechanism Output';
plotNames.legend = {'M1','M2'};

simplePlot(m1_hat,[0, 0,.5],m2_hat,[0,.5,.5],plotNames,legendLocation)

subplot(1,3,2); hold on
plotNames.title  = 'Lag1 and Lag2 Outputs';
plotNames.xlabel = 'Stimuli';
plotNames.ylabel = 'Lag Output';
plotNames.legend = {'Lag1','Lag2'};

simplePlot(Lag1_hat,[0, 0,.5],Lag2_hat,[0,.5,.5],plotNames,legendLocation)
% init the plot
subplot(1,3,3);
hold on;
plotNames.title  = 'Model Fit';
plotNames.xlabel = 'Stimuli';
plotNames.ylabel = 'Lag (S)';
plotNames.legend = {'Lag','Predicted Lag'};

simplePlot(lags(:),[0, 0,0],lagsFromFit,[220 195 256]./256,plotNames,legendLocation)
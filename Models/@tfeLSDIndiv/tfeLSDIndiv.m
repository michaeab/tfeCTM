classdef tfeLSDIndiv < tfeCTM
% tfeNakaRushtonDirection
%  Create at tfeIndivDirection object
%
% Syntax:
%    tfe = tfeIndivDirection(directions,varargin);
% 
% Description:
%     Implements a model that is quadratic in the color contrast of the
%     stimulus. Stimulus specified as unit vector direction and contrast.
%
%     Inherits optional key/value pairs from parent class tfeQCM, plus
%     those specified below.
%
% Inputs:
%    directions                - Matrix specifying the possible stimulus
%                                directions.  Each direction is in a
%                                column. Dimensionality of stimuli and
%                                number of directions are inferred from
%                                this.  We need to pass this because we
%                                need some way of associating the
%                                parameters for each direction with the
%                                actual directions passed to the
%                                compute/fit routines.
%
% Outputs:
%    obj                       - The object.
%
% Optional key/value pairs:
%      'lockOffsetToZero'      - Logical (default false). Force fits to go through 0 at 0 contrast
%      'commonAmplitude'       - Logical (default false). Force common amplitude across directions.
%      'commonSemi'            - Logical (default false). Force common semi-saturation across directions.
%      'commonExp'             - Logical (default false). Force common exponent across directions.
%      'commonOffset'          - Logical (default false). Force common offset across directions.
%
% See also:
%

% History:
%   12/09/18 dhb       Wrote it.

    % Public, read-only properties.
    properties (SetAccess = private, GetAccess = public)
        % Fitting constraints
        lockOffsetToZero = false;
        commonLambda = false;
        commonExponent = false; 

        % Number of color directions.  We need to know this to set up
        % parameters.
        directions = [];
        contrasts = [];
        nDirections = 1;
    end
    
    % Private properties. Only methods of the parent class can set these
    properties(Access = private)
    end
    
    % Public methods
    methods  
    end
    
    properties (Dependent)
    end
    
    % Methods.  Most public methods are implemented in a separate function,
    % but we put the constructor here.
    methods (Access=public)
        % Constructor
        function obj = tfeLSDIndiv(directions,contrasts,varargin)
           
            % Parse input. Need to add any key/value pairs that need to go
            % to the tfe parent class, as well as any that are QCM
            % specific.
            p = inputParser; p.KeepUnmatched = true;
            p.addRequired('directions',@isnumeric);
            p.addRequired('contrasts',@isnumeric);
            p.addParameter('lockOffsetToZero',false,@islogical);
            p.addParameter('commonLambda',false,@islogical);
            p.addParameter('commonExponent',false,@islogical);

            p.parse(directions,contrasts,varargin{:});
            
            % Base class constructor
            obj = obj@tfeCTM(varargin{:});
            
            % Set properties for this class
            obj.directions = directions;
            obj.contrasts = contrasts;
            obj.dimension = size(directions,1);
            obj.nDirections = size(directions,2);
            obj.commonLambda = p.Results.commonLambda;
            obj.commonExponent = p.Results.commonExponent;
        end
    end 
    
    % Get methods for dependent properties
    methods
    end
    
    % Methods may be called by the subclasses, but are otherwise private 
    methods (Access = protected)
    end
    
    % Methods that are totally private (subclasses cannot call these)
    methods (Access = private)
    end
    
end

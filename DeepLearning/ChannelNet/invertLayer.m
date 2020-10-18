classdef invertLayer < nnet.layer.Layer
    methods
        function layer = invertLayer(name) 
            % Set layer name
            if nargin == 1
                layer.Name = name;
            end
            % Set layer description
            layer.Description = 'invertLayer'; 
        end
        function Z = predict(layer,X)
            % Forward input data through the layer and output the result
            Z = -1*X;
        end
        function dLdX = backward(layer, X ,Z,dLdZ,memory)
            % Backward propagate the derivative of the loss function through 
            % the layer 
            dLdX = -1.* dLdZ;
        end
    end
 end
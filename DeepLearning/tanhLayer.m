 classdef tanhLayer < nnet.layer.Layer
    methods
        function layer = tanhLayer(name) 
            % Set layer name
            if nargin == 2
                layer.Name = name;
            end
            % Set layer description
            layer.Description = 'tanhLayer'; 
        end
        function Z = predict(layer,X)
            % Forward input data through the layer and output the result
            Z = (1-exp(-2*X))./(exp(-2*X)+1);
        end
        function dLdX = backward(layer, X ,Z,dLdZ,memory)
            % Backward propagate the derivative of the loss function through 
            % the layer 
            dLdX = (1-(Z).^2) .* dLdZ;
        end
    end
 end
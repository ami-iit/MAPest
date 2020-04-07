
% Copyright (C) 2017 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

function pinvDampA = pinvDamped(A,regDamp)

    % PINVDAMPED computes the damped pseudoinverse of matrix A
    %
    % FORMAT: pinvDampA = pinvDamped(A,regDamp)   
    %
    % INPUT:  - A = [n * m] rotation matrix
    %         - regDamp = regularization parameter
    %
    % OUTPUT: - pinvDampA = [m * n] matrix pseudoinverse of A
    %
    % Authors: Daniele Pucci, Marie Charbonneau, Gabriele Nava
    %          
    %          all authors are with the Italian Istitute of Technology (IIT)
    %          email: name.surname@iit.it
    %
    % Genoa, Dec 2017
    %

    %% --- Initialization ---

    pinvDampA = transpose(A)/(A*transpose(A) +regDamp*eye(size(A,1)));   
end
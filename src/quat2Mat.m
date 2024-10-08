
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [R] = quat2Mat(q)
%QUAT2MAT converts a quaternion into a rotation matrix.
% This function maps exactly the same code of iDynTree function.
%
% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia


% Check if quaternion is normalized, otherwise normalize it
if ~(norm(q) == 1.0)
    q = q / norm(q);
end

% Initialize the output matrix
R = zeros(3);

% Fill the rotation matrix
R(1,1) = 1 - 2*(q(4)*q(4) + q(3)*q(3));
R(2,2) = 1 - 2*(q(4)*q(4) + q(2)*q(2));
R(3,3) = 1 - 2*(q(3)*q(3) + q(2)*q(2));

R(1,2) = 2 * q(2)*q(3) - 2 * q(4)*q(1);
R(2,1) = 2 * q(2)*q(3) + 2 * q(4)*q(1);

R(1,3) = 2 * q(2)*q(4) + 2 * q(3)*q(1);
R(3,1) = 2 * q(2)*q(4) - 2 * q(3)*q(1);

R(2,3) = 2 * q(3)*q(4) - 2 * q(2)*q(1);
R(3,2) = 2 * q(3)*q(4) + 2 * q(2)*q(1);

end

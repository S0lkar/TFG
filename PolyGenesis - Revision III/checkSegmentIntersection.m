function [doesIntersect, intersection] = checkSegmentIntersection(A, B)
% https://matlabgeeks.com/tips-tutorials/computational-geometry/find-intersection-of-two-lines-in-matlab/
% Check if two line segments (A and B) intersect in 2D space.
% 
% Usage: [doesIntersect, intersection] = checkSegmentIntersection(A, B, plotResults)
% 
% Inputs:
%  A and B are setup with two rows and 2 columns for the 2 points which
%  define the line segments and 2 columns for 2 dimensions
% 
% Outputs:
%  doesIntersect - provides a boolean about whether the segments
%    intersect.
%  intersection - The second output argument provides the point at which the intersection
%    occurs.
%
% Credit: General explanation for this is from https://stackoverflow.com/a/565282
% by Gareth Rees.  He does a wonderful job explaining the math as well.
% While preparing this post I ran across his response, and I can't do it
% more justice, so here is his implementation in MATLAB.
%
% Vipul Lugade
% matlabgeeks.com
% 09/02/2018

% initialize
doesIntersect = false;
intersection = NaN;

% Given two line segments:
% segment1 = p + t*r
% segment2 = q + u*s
% Can solve intersection of two segments and values of u and t where
% intersection occurs (where x is cross product)
% t = (q-p) x s/(r x s)
% u = (q-p) x r/(r x s)

% Solve for all of these variables given the two line segments
    p = A(1,:);
    r = parameterizeLine(A(1,:), A(2,:));
    q = B(1,:);
    s = parameterizeLine(B(1,:), B(2,:));
% Solve for cross products
    r_cross_s = Cross(r, s);
    q_p_cross_s = Cross(q-p, s);
    q_p_cross_r = Cross(q-p, r);
% solve for t and u
    t = q_p_cross_s / r_cross_s;
    u = q_p_cross_r / r_cross_s;

% Five possibilities
% 1) Collinear and overlapping
% 2) Collinear and disjoint
% 3) Parallel and non-intersecting
% 4) Not parallel and intersect
% 5) Not parallel and non-intersecting

%% First Possibility
if r_cross_s == 0
    if q_p_cross_r == 0
        t0 = dot(q-p,r)/dot(r,r);
        if t0 >= 0 && t0 <= 1
            doesIntersect = true;
            % return a line segment where intersection occurs
            intersection = [p; p+t0*r];
        end
    end
else %% Fourth possibility
    if t >= 0 && t <= 1 && u >=0 && u <= 1
        doesIntersect = true;
        intersection = p + t * r;
    end    
end
%% Second, third, and fifth possibilities return initialized values
end


%% Cross product returning z value
function z = Cross(a, b)
    z = a(1)*b(2) - a(2)*b(1);
end

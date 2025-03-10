syms x1 x2

eq1 = 2*(x1 - x2)^2 == .5^2; eq2 = sqrt(x2^2 + x1^2) == 2.7;

sol = solve([eq1, eq2], [x1 x2]); disp([sol.x1 sol.x2]);  
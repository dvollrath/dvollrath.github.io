
// Form the actual cost data we want from Use and Make tables, along with info on value-added of industries
mat i = [1 \ 1]
mat e = [1, 1, 1]

mat U = [10, 30 \ 20, 20 \ 5, 5] // Use table
mat FC = [25 \ 15 \ 0] // final use of commodities
mat VI = [10, 5] // value added of industries
mat FACTOR = [4, 3 \ 2, 1] // matrix of factor costs of industry i on factor j
mat V = [26, 27.5 , 1 \ 35.75, 22, .5] // make table

mat XC = U*i + FC // gross output of commodities

mat A = V*inv(diag(XC)) // share of commodity j built by industry i
mat Z = A*U // total spending by industry j on industry i

mat XI = VI' + Z'*i // gross output of industries
mat FI = XI - Z*i // final use of *industries*

// Now actually calculate the cost shares and elasticities
mat Z = Z' // flip to match the theory - a row is an industry, and columns are costs of that industry on other industry inputs

mat b = FI*inv(i'*FI) // vector of shares of final use

mat COST = Z*i + FACTOR*i // sum up for each industry their total costs
mat ALPHA = inv(diag(COST))*Z // share of each intermediate in total costs (the alpha terms)
mat BETA = inv(diag(COST))*FACTOR // share of each factor in total costs (the beta terms)
mat E = b'*inv(I(2) - ALPHA)*BETA // calculate elasticities


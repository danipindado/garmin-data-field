// https://stackoverflow.com/a/39881366

class Matrix {

    function addMatrices(m, n) 
    {        
        return ([m[0] + n[0], m[1] + n[1], m[2] + n[2], m[3] + n[3]]);
    }

    function dotMatrices(m, n) 
    {        
        return ([m[0] * n[0] + m[1] * n[2] , m[0] * n[1] + m[1] * n[3] , m[2] * n[0] + m[3] * n[2] , m[2] * n[1] + m[3] * n[3] ]);
    }

    function transposeMatrix(m) 
    {        
        return ([m[0], m[2], m[1], m[3]]);
    }

    function getMatrixInverse(m) 
    {        
        var determinant = m[0]*m[3]-m[1]*m[2];

        return ([m[3] / determinant, -1.0 * m[1] / determinant, -1.0 * m[2] / determinant, m[0] / determinant]);
    }
}
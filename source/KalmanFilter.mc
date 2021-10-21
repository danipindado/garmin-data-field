// Height and vertical velocity Kalman filtering on MS5611 barometer, https://www.blogger.com/profile/18333325512054999364
// https://shepherdingelectrons.blogspot.com/2017/06/height-and-vertical-velocity-kalman.html

class KalmanFilter {

    // State variables
    public var height;
    public var kalmanvel_z;

    protected var R11;
    protected var timeslice;
    protected var var_acc;

    protected var Q11;
    protected var Q12;
    protected var Q21;
    protected var Q22;
        
    protected var m11;
    protected var m21;
    protected var m12;
    protected var m22;

    function initialize(x0, v0, dt, meas_noise_var, process_var)
    {
        height = x0;
        kalmanvel_z = v0;

        timeslice = dt;
        var_acc = process_var;

        R11 = meas_noise_var;

        Q11 = var_acc * 0.25 * (timeslice * timeslice * timeslice * timeslice);
        Q12 = var_acc * 0.5 * (timeslice * timeslice * timeslice);
        Q21 = var_acc * 0.5 * (timeslice * timeslice * timeslice);
        Q22 = var_acc * (timeslice * timeslice);
        
        m11 = 1.0;
        m21 = 0.0;
        m12 = 0.0;
        m22 = 1.0;

    }

    // baro_height should be set as the height derived from raw barometer reading every time we have a new reading.  
    // We are then ready to run the Kalman filter every program loop, by calling KalmanPosVel().  
    // Note var_acc and R11 are equivalent to the y-axis and x-axis values respectively in the 2d plots above.  
    // Please experiment with these values yourself - I have not finalised them myself yet!


    function KalmanPosVel(baro_height)
    {
        var ps1, ps2, opt;
        var pp11, pp12, pp21, pp22;
        var inn, ic, kg1, kg2;

        ps1 = height  + timeslice * kalmanvel_z;
        ps2 = kalmanvel_z;

        opt = timeslice * m22;
        pp12 = m12 + opt + Q12;
        
        pp21 = m21 + opt;
        pp11 = m11 + timeslice * (m12 + pp21) + Q11;
        pp21 += Q21;
        pp22 = m22 + Q22;
        
        inn = baro_height - ps1;
        ic = pp11 + R11;

        kg1 = pp11 / ic;
        kg2 = pp21 / ic;

        height = ps1 + kg1 * inn;
        kalmanvel_z = ps2 + kg2 * inn;

        opt = 1 - kg1;
        m11 = pp11 * opt;
        m12 = pp12 * opt;
        m21 = pp21 - pp11 * kg2;
        m22 = pp22 - pp12 * kg2;
    }
}
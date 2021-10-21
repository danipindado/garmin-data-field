class VerticalState extends KalmanFilter{

    function initialize(y0) 
    {        
        KalmanFilter.initialize(y0, 0.0, 1.0, 2.778, 0.000049);
    }

    function update(raw_altitude) 
    {
        KalmanFilter.KalmanPosVel(raw_altitude);
    }
}
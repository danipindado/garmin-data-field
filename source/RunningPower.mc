using Toybox.Math;

class RunningPower {

    hidden var slope;
    function initialize() 
    {        
        slope = new EstimatedSlope();
    }

    //  Hans van Dijk and Ron van Megen
    // https://www.trainingpeaks.com/blog/running-with-power-what-it-can-tell-us-about-our-human-limits/
    function DijkAndMegen(speed, distance, altitude) 
    {
        
        //TODO: weight is hard coded here (83). get from garmin of from parameter. 
        // Also cd*A is hard coded. maybe get estimate from heigth
        var runningResistance = 0.98 * 83 * speed;
        var airResistance = 0.5 * 1.205 * 0.24 * Math.pow(speed, 3);
        //TODO: this is a dirty hack because the 645M does an autocalibration at the beginning of the activity which messes with power
        var currentSlope = (distance > 20.0) ? slope.getSlope(distance,altitude) : 0.0;
        var climbingResistance = currentSlope * 83 * 9.81 * speed * 0.01 * (45.6 + 1.1622 * 100 * currentSlope);
        return (runningResistance + airResistance + climbingResistance);
    }
}
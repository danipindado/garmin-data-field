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
        var currentSlope = slope.getSlope(distance,altitude);
        var climbingResistance = currentSlope * 83 * 9.81 * (45.6 + 116.22 * currentSlope) / 100;
        return (runningResistance + airResistance + climbingResistance);
    }
}
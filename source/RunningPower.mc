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
        var runningResistance = 0.98 * 83.0 * speed;
        var airResistance = 0.5 * 1.205 * 0.24 * Math.pow(speed, 3);
        //TODO: this is a dirty hack because the 645M does an autocalibration at the beginning of the activity which messes with power
        var currentSlope = (distance > 20.0) ? slope.getSlope(distance,altitude) : 0.0;
        var climbingResistance = currentSlope * 83.0 * 9.81 * speed * 0.01 * (45.6 + 1.1622 * 100.0 * currentSlope);
        return (runningResistance + airResistance + climbingResistance);
    }

    //An Improved GAP Model 
    // https://medium.com/strava-engineering/an-improved-gap-model-8b07ae8886c3
    function Strava(speed, distance, altitude) 
    {
        //TODO: this is a dirty hack because the 645M does an autocalibration at the beginning of the activity which messes with power
        var currentSlope = (distance > 20.0) ? slope.getSlope(distance,altitude) : 0.0;
        var pace_adjustment = ((((-45.704 * currentSlope - 3.3882 ) * currentSlope + 18.814)* currentSlope + 3.0266) * currentSlope + 0.98462);

        // c-value (the running economy or Energy Cost of Running) of 0.98 kJ/kg/km, body weight and speed
        var runningresistance = 0.98 * 83.0 * speed * pace_adjustment;
    return (runningresistance);

    }
}
using Toybox.Math;

class RunningPower {

    //An Improved GAP Model 
    // https://medium.com/strava-engineering/an-improved-gap-model-8b07ae8886c3
    // # https://quantixed.org/2020/05/19/running-free-calculating-efficiency-factor-in-r/
    function Strava(speed, currentSlope) 
    {
        var pace_adjustment = ((((-45.704 * currentSlope - 3.3882 ) * currentSlope + 18.814)* currentSlope + 3.0266) * currentSlope + 0.98462);

        // c-value (the running economy or Energy Cost of Running) of 0.98 kJ/kg/km, body weight and speed
        var runningresistance = 0.98 * 83.0 * speed * pace_adjustment;
    return (runningresistance);

    }
}
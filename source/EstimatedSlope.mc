class EstimatedSlope {

    hidden var kalmanFilter;
    hidden var currentAltitude = null;
    hidden var currentDistance = null;
    hidden var previousAltitude = null;
    hidden var previousDistance = null;

    function initialize() 
    {        
        kalmanFilter = new SimpleKalmanFilter(0.1, 0.1, 0.001);
    }

    function getSlope(distance,raw_altitude) 
    {
        var slope;
        self.previousDistance = self.currentDistance;
        self.previousAltitude = self.currentAltitude;
        self.currentDistance = distance;
        self.currentAltitude = kalmanFilter.updateEstimate(raw_altitude);

        if( (self.previousAltitude != null) &&
            (self.currentAltitude != null) && 
            (self.previousDistance != null) &&
            (self.currentDistance != null) &&
            (self.previousDistance != self.currentDistance))
        {
            slope = (self.currentAltitude-self.previousAltitude)/(self.currentDistance-self.previousDistance);
        }
        else
        {
            slope = 0.0;
        }

        return (slope);
    }
}
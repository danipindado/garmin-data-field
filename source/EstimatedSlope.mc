class EstimatedSlope {

    hidden var altitudeFilter;
    hidden var distanceFilter;
    hidden var slope = 0.0;
    hidden var currentAltitude = null;
    hidden var previousAltitude = null;
    hidden var currentDistance = null;
    hidden var previousDistance = null;

    function initialize() 
    {        
        altitudeFilter = new SimpleKalmanFilter(2, 2, 0.2);
        distanceFilter = new SimpleKalmanFilter(5, 5, 0.2);
    }

    function getSlope(raw_distance,raw_altitude) 
    {
        self.previousAltitude = self.currentAltitude;
        self.currentAltitude = altitudeFilter.updateEstimate(raw_altitude);

        self.previousDistance = self.currentDistance;
        self.currentDistance = distanceFilter.updateEstimate(raw_distance) ;

        if( (self.previousAltitude != null) &&
            (self.currentAltitude != null) && 
            (self.previousDistance != null) &&
            (self.currentDistance != null) &&
            (self.previousDistance != self.currentDistance))
        {
            self.slope = (self.currentAltitude-self.previousAltitude)/(self.currentDistance-self.previousDistance);
        }
        // System.println("slope: " + slope);

        return (self.slope);
    }
}
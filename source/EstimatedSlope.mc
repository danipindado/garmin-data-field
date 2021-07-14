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
        altitudeFilter = new SimpleKalmanFilter(0.25, 0.25, 0.0079);
        distanceFilter = new SimpleKalmanFilter(3.9, 3.9, 0.01);
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
        // System.println("raw_altitude: " + raw_altitude);
        // System.println("raw_distance: " + raw_distance);
        // System.println("self.currentAltitude: " + self.currentAltitude);
        // System.println("self.previousAltitude: " + self.previousAltitude);
        // System.println("self.currentDistance: " + self.currentDistance);
        // System.println("self.previousDistance: " + self.previousDistance);
        // System.println("=========================================");

        return (self.slope);
    }
}
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class customdatafieldView extends Ui.DataField {

	hidden var elapsedDistance = 0.0;
    hidden var lapStartDistance = 0.0;
	hidden var lapDistance = 0.0;
    hidden var elapsedEnergy = 0.0;
	hidden var lapStartEnergy = 0.0;
	hidden var lapEnergy = 0.0;
    hidden var elapsedTime = 0.0;
    hidden var lapStartTime = 0.0;
    hidden var lastComputeTime = 0.0;
    hidden var lapTime = 0.0;
    hidden var currentSpeed = 0.0;
    hidden var lapPower = 0.0;
    hidden var averagePower = 0.0;
    hidden var currentPower = 0.0;
    hidden var hrValue = 0;
    hidden var runningPower = 0.0;
    var mFitContributor;

    function initialize() {
        DataField.initialize();
        runningPower = new RunningPower();
        mFitContributor = new FitContributor(self);
    }
            
    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
            
        elapsedTime = info.timerTime != null ? info.timerTime : 0;
        hrValue = info.currentHeartRate != null ? info.currentHeartRate : 0;        
        if(elapsedTime != lastComputeTime)
        {
            elapsedDistance = info.elapsedDistance != null ? info.elapsedDistance : 0.0;
            lapDistance = elapsedDistance - lapStartDistance;        
            lapTime = elapsedTime - lapStartTime;
            currentPower = info.altitude != null ? runningPower.DijkAndMegen(info.currentSpeed, elapsedDistance, info.altitude) : 0.0;
            elapsedEnergy += elapsedTime > 0 ? (currentPower * (elapsedTime - lastComputeTime)/1000.0) : 0.0;
            lapEnergy = elapsedEnergy - lapStartEnergy;
            lapPower = lapTime > 0 ? 1000.0 * lapEnergy / lapTime : 0.0;
            averagePower = elapsedTime > 0 ? 1000.0 * elapsedEnergy / elapsedTime : 0.0;
            lastComputeTime = elapsedTime;
            mFitContributor.compute([currentPower]);
        }
        // System.println("currentPower: " + currentPower);
        // System.println("lapPower: " + lapPower);
        // System.println("averagePower: " + averagePower);

        // System.println("elapsedTime: " + elapsedTime);
        // System.println("lapTime: " + lapTime);
        // System.println("elapsedEnergy: " + elapsedEnergy);
        // System.println("averagePower: " + averagePower);
    }
    
    function onTimerLap(){
    	lapStartDistance = elapsedDistance;
    	lapStartTime = elapsedTime;
        lapStartEnergy = elapsedEnergy;
    }

    function onWorkoutStepComplete()
    {
        onTimerLap();
    }
    
    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
    	
    	var width = dc.getWidth();
    	var height = dc.getHeight();
    	
    	var backgroundColor = getBackgroundColor();
    	var valueColor = backgroundColor == Graphics.COLOR_WHITE ? Graphics.COLOR_BLACK : Graphics.COLOR_WHITE;
    	var labelColor = backgroundColor == Graphics.COLOR_WHITE ? Graphics.COLOR_DK_GRAY : Graphics.COLOR_LT_GRAY;
    	var valueSize = Graphics.FONT_LARGE;
    	var labelSize = Graphics.FONT_TINY;
    	
    	var distanceYPosition = (height > 214) ? height * .04 : height * .03;
    	
        // Set the background color
        dc.setColor(backgroundColor, backgroundColor);
        dc.fillRectangle(0, 0, width, height);
        
        // Draw grid
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, height * .2, width, height * .2);
        dc.drawLine(0, height * .5, width, height * .5);
        dc.drawLine(0, height * .8, width, height * .8);
        dc.drawLine(width * .5, height * .2, width * .5, height * .8);
        
        // this is going up here because we're gonna shift some stuff based on distance
        var distanceValue = elapsedDistance * 0.001;
        var distanceUnit = "km";
        if(System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE)
        {
        	distanceValue = elapsedDistance * 0.000621371;
            distanceUnit = "mi";
        }
        
        var distanceLabelX = (distanceValue > 10.0) ? width * .675 : width * .6375;
        var distanceXPosition = (distanceValue > 10.0) ? width / 2 : width * .4625;
        
        // Draw Labels
        dc.setColor(labelColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(distanceLabelX, height * .0725, labelSize, distanceUnit, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * .25, height * .22, labelSize, "Timer", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * .75, height * .22, labelSize, "Power", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * .25, height * .52, labelSize, "Avg. Power", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * .75, height * .52, labelSize, "Lap Power", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width * .33, height * .82, labelSize, "HR", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(valueColor, Graphics.COLOR_TRANSPARENT);
                
        dc.drawText(distanceXPosition, distanceYPosition, valueSize, distanceValue.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER);
        
        var timeText;
        var seconds = (elapsedTime * 0.001).toNumber();
		if(elapsedTime != null && elapsedTime > 0){
			var timerValueHours = (seconds / 3600).toNumber();
        	var timerValueMinutes = ((seconds % 3600) / 60).toNumber();
        	var timerValueSeconds = ((seconds % 3600) % 60).toNumber();
        	
        	if(timerValueHours > 0){
        		timeText = timerValueHours.format("%d")+":"+timerValueMinutes.format("%02d")+":"+timerValueSeconds.format("%02d");
        		dc.drawText(width * .25, height * .31, Graphics.FONT_MEDIUM, timeText, Graphics.TEXT_JUSTIFY_CENTER);
        	}else{
        		timeText = timerValueMinutes.format("%d")+":"+timerValueSeconds.format("%02d");
        		dc.drawText(width * .25, height * .31, valueSize, timeText, Graphics.TEXT_JUSTIFY_CENTER);
        	}
        } else{
        	timeText = "0:00";
        	dc.drawText(width * .25, height * .315, valueSize, timeText, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        var powerText;
  		    
        if (currentPower == 0) {
        	powerText = "--";
        } else {
        	powerText = currentPower.format("%d");
		}
        
        dc.drawText(width * .75, height * .315, valueSize, powerText, Graphics.TEXT_JUSTIFY_CENTER);
        //System.println("power: " + currentPower);

		var lapPowerText;
		if(lapEnergy > 0){
			lapPowerText = lapPower.format("%d");
		}else {
			lapPowerText = "--";
		}
		
		dc.drawText(width * .75, height * .615, valueSize, lapPowerText, Graphics.TEXT_JUSTIFY_CENTER);
        
        var avgPowerText;
        if(averagePower > 0){
        	avgPowerText = averagePower.format("%d");
        }else {
        	avgPowerText = "--";
        }
        
		dc.drawText(width * .25, height * .615, valueSize, avgPowerText, Graphics.TEXT_JUSTIFY_CENTER);
		// System.println("Avg. Power " + averagePower);
		
		var hrText;
        if (hrValue == 0) {
        	hrText = "--";
        } else {
        	hrText = hrValue.format("%d");
		}
		dc.drawText(width / 2, height * .82, valueSize, hrText, Graphics.TEXT_JUSTIFY_CENTER);

    }

    function onTimerStart() {
        mFitContributor.setTimerRunning( true );
    }

    function onTimerStop() {
        mFitContributor.setTimerRunning( false );
    }

    function onTimerPause() {
        mFitContributor.setTimerRunning( false );
    }

    function onTimerResume() {
        mFitContributor.setTimerRunning( true );
    }    

}

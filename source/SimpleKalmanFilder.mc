// simplekalmanfilter - a Kalman Filter implementation for single variable models.
// # Created by Denys Sene, January, 1, 2017.
// Released under MIT License - see LICENSE file for details.
// https://github.com/denyssene/simplekalmanfilter

class SimpleKalmanFilter {

    hidden var err_measure;
    hidden var err_estimate;
    hidden var q;
    hidden var current_estimate;
    hidden var last_estimate;
    hidden var kalman_gain;

    function initialize(mea_e, est_e, q_e) 
    {
        err_measure=mea_e;
        err_estimate=est_e;
        last_estimate=null;
        q = q_e;
    }

    function updateEstimate(mea) 
    {
        if(last_estimate == null)
         {
            last_estimate = mea;
         }
        kalman_gain = err_estimate/(err_estimate + err_measure);
        current_estimate = last_estimate + kalman_gain * (mea - last_estimate);
        err_estimate =  (1.0 - kalman_gain) * err_estimate +(last_estimate-current_estimate).abs()*q;
        last_estimate=current_estimate;
        return (current_estimate);
    }

    function setMeasurementError(mea_e)
    {
        err_measure=mea_e;
    }


    function setEstimateError(est_e)
    {
        err_estimate=est_e;
    }


    function setProcessNoise(q)
    {
        q=q;
    }


    function getKalmanGain()
    {
        return (kalman_gain);
    }


    function getEstimateError()
    {
        return (err_estimate);
    }

}
// simplekalmanfilter - a Kalman Filter implementation for single variable models.
// # Created by Denys Sene, January, 1, 2017.
// Released under MIT License - see LICENSE file for details.
// https://github.com/denyssene/simplekalmanfilter

class SimpleKalmanFilter {

    hidden var _err_measure;
    hidden var _err_estimate;
    hidden var _q;
    hidden var _current_estimate;
    hidden var _last_estimate;
    hidden var _kalman_gain;

    function initialize(mea_e, est_e, q) 
    {
        _err_measure=mea_e;
        _err_estimate=est_e;
        _last_estimate=null;
        _q = q;
    }

    function updateEstimate(mea) 
    {
        if(_last_estimate == null)
         {
            _last_estimate = mea;
         }
        _kalman_gain = _err_estimate/(_err_estimate + _err_measure);
        _current_estimate = _last_estimate + _kalman_gain * (mea - _last_estimate);
        _err_estimate =  (1.0 - _kalman_gain) * _err_estimate + Toybox.Lang.Float.abs(_last_estimate-_current_estimate)*_q;
        _last_estimate=_current_estimate;
        return (_current_estimate);
    }

    function setMeasurementError(mea_e)
    {
        _err_measure=mea_e;
    }


    function setEstimateError(est_e)
    {
        _err_estimate=est_e;
    }


    function setProcessNoise(q)
    {
        _q=q;
    }


    function getKalmanGain()
    {
        return (_kalman_gain);
    }


    function getEstimateError()
    {
        return (_err_estimate);
    }

}
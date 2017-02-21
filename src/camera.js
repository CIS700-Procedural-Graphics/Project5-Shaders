const THREE = require('three');

class CameraController {
    constructor(duration, func, startFunc = null, onExitFunc = null,) {
        this.func = func;
        this.time = 0;
        this.duration = duration;
        this.startFunc = startFunc;
        this.onExitFunc = onExitFunc;
    }

    setActive(currentTime)
    {
        if(this.startFunc != null)
            this.startFunc();
        
        // This must be after the callback, because controllers may reset the time ;)
        this.time = currentTime;
    }

    update(currentTime)
    {
        var t = THREE.Math.clamp((currentTime - this.time) / this.duration, 0.0, 1.0);
        this.func(t);    
        return t >= 1;
    }

    onExit()
    {
        if(this.onExitFunc != null)
            this.onExitFunc();
    }
}

export {CameraController}
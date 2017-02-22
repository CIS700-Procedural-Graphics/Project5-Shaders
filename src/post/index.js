
// This file exports available shaders to the GUI.

// don't worry about this one. This is just to apply no filter
export function None(renderer, scene, camera) {
    return {
        initGUI: function(gui) {

        },

        render: function() {
            renderer.render(scene, camera);
        }
    }
}

// follow this syntax to make your shaders available to the GUI
export {default as Grayscale} from './grayscale'

export {default as Pointilism} from './pointilism'

export {default as Sobel} from './sobel'

export {default as NoiseWarp} from './noisewarp'

export {default as Bloom} from './bloom'
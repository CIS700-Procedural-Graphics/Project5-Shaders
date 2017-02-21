
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
export {default as ColorFilter} from './color_filter'
export {default as LinearToneMapping} from './linearToneMapping'
export {default as ReinhardToneMapping} from './reinhardToneMapping'
export {default as FilmicToneMapping} from './filmicToneMapping'
export {default as Vignette} from './vignette'
export {default as LensDistortion} from './lensDistortion'
// export {default as Warp} from './warp'

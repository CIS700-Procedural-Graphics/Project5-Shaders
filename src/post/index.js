
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
export {default as InClassPostRedAlter} from './inClassPostRedAlter'
export {default as Edges} from './edgeWithSobel'
export {default as Vignette} from './vignette'
export {default as FishEye} from './fishEye'
export {default as ChromaticAberration} from './chromaticAberration'
export {default as Inverse} from './inverse'

export {default as CoolEffect1} from './coolEffect1'
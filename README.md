# [HW4: Shape Grammar](https://github.com/CIS700-Procedural-Graphics/Project4-Shape Grammar)

## Project Description

A bunch of shaders and post processing effects

### Iridescence Shader:

color is view point dependent shader;

### Toon Shader:

color is approximated to the nearest bucket;

### Pointilism Shader:

Overlay noise on top of the mesh; can control the threshold

### Tone Mapping:

#### Linear Tone mapping

Better blacks; can control gamma and Exposure

#### Reinhard Tone mapping

Better blacks, less saturated whites; can control gamma and Exposure

#### Filmic Tone mapping

Like reinhard but even better blacks, similarly less saturated whites; can control gamma and Exposure

#### Vignette

creates a vignette as a post process effect

#### Lens Distortion mapping

creates a lens centered at the origin, that magnifies the stuff behind it to the point of distortion.

#import "@preview/touying:0.6.1": *
#import "template.typ": *

#show: rp-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: "Interoperabilidad",
    authors: ("Vicente González", "Diego García"),
    professor: "Nancy Hitschfeld",
    course: [CC7515-1 --- Computación en GPU],
    number: 3,
  ),
)

#title-slide()

= Introducción
==
- CUDA
- OpenCL
- Compute Shaders

= CUDA
#slide[
  #set text(size: 22pt)
  - La más conocida para GPGPU

  - Consiste en *mapear* los recursos de OpenGL a CUDA

  - Pipeline:
    + Inicializar contexto OpenGL
    + Crear los objetos de OpenGL
    + Registrar los objetos en CUDA
    + _Mapear_ los objetos a recursos CUDA
    + Ejecutar los kernels
    + _Unmapear_ los objetos a recursos CUDA
    + Renderizar
]

== Registrar
#slide[
  #set text(size: 20pt)
  ```cpp
  struct cudaGraphicsResource* resource;
  // Para un buffer
  cudaGraphicsGLRegisterBuffer(&resource, VBO, flags);
  // Para una imagen/textura
  cudaGraphicsGLRegisterImage(&resource, IMG, IMG_TYPE, flags);
  ```
]

== Mapear
#slide[
  #set text(size: 22pt)
  - Para mapear:

    ```cpp
    cudaGraphicsMapResources(count, resource, stream);
    ```
  - Para unmapear
    ```cpp
    cudaGraphicsUnmapResources(count, resource, stream);
    ```
]

== Obtener
#slide[
  #set text(size: 20pt)
  ```cpp
  void* d_data;
  cudaGraphicsResourceGetMappedPointer(&d_data, size, resource);
  ```
]

== Ejemplo
#focus-slide(icon: image("github-mark-white.svg"), link: "https://github.com/Seivier/NBodyCuda/tree/main")[]


= OpenCL

#slide[
  #set text(size: 22pt)
  - Es multi-plataforma.
  - Basado en *adquirir* y *liberar* la memoria.
  - Pipeline:
    + Crear el contexto de OpenGL
    + Crear la queue de OpenCL con el contexto de GL
    + Crear buffers de OpenCL desde los de GL
    + Pedir la memoria
    + Ejecutar los kernels
    + Liberar la memoria
    + Renderizar
]

== Contexto
#slide[
  Depende del sistema operativo:
  #columns(
    2,
    [
      #set text(size: 12pt)
      - MacOS
        ```cpp
        CGLContextObj kCGLContext = CGLGetCurrentContext();
        CGLShareGroupObj kCGLShareGroup = CGLGetShareGroup(kCGLContext);

        cl_context_properties properties[] = { CL_CONTEXT_PROPERTY_USE_CGL_SHAREGROUP_APPLE, (cl_context_properties)kCGLShareGroup, 0};
        ```
      - Linux
        ```cpp
        cl_context_properties properties[] = {
          CL_GL_CONTEXT_KHR, (cl_context_properties)glXGetCurrentContext(),
          CL_GLX_DISPLAY_KHR, (cl_context_properties)glXGetCurrentDisplay(),
          CL_CONTEXT_PLATFORM, (cl_context_properties)platform, 0};
        ```
      - Windows
        ```cpp
          cl_context_properties properties[] = {
            CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext(),
            CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(),
            CL_CONTEXT_PLATFORM, (cl_context_properties)platform, 0};
        ```
    ],
  )
]

== Registrar
```cpp
cl_mem mem;
mem = clCreateFromGLBuffer(context, flags, VBO, &error);
```

== Manipular
- Para obtener:
  ```cpp
  error = clEnqueueAcquireGLObjects(queue, 1, &mem, 0, 0, 0);
  ```
- Para liberar:
  ```cpp
  error = clEnqueueReleaseGLObjects(queue, 1, &mem, 0, 0, 0);
  ```

== Ejemplo
#focus-slide(icon: image("github-mark-white.svg"), link: "https://github.com/Seivier/NBodyCuda/tree/main")[
  en example/opencl
]

= Compute Shaders
== Compute Shaders
- Disponible a partir de OpenGL 4.3.
- Vive en un pipeline independiente a todo.
- Necesita su propio programa.
- Pipeline:
  + Crear el contexto de OpenGL.
  + Compilar el compute shader.
  + Ejecutar el shader (_dispatch_).
  + Usar barreras para esperar a que termine.
  + Renderizar

== Compute Shader
#slide[
  #set text(size: 14pt)
  ```glsl
  #version 430 core
  // el localSize o blockSize
  layout (local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

  // buffers
  layout (std430, binding = 0) buffer particles {
    ...
  };

  // vars
  layout (location = 0) uniform uint size;

  void main() {
    uint index = gl_GlobalInvocationID.x; // global id
    // ...
  }
  ```
]

== Compute Shader
#slide[
  #set text(size: 18pt)
  #columns(
    2,
    [
      - Para obtener la cantidad de _work groups_ (bloques):
        ```glsl uvec3 n = gl_NumWorkGroups```

      - Para obtener el tamaño de los _work groups_:
        ```glsl uvec3 size = gl_WorkGroupSize```

      - Para obtener el ID del _work group_ actual:
        ```glsl uvec3 blockId = gl_WorkGroupID```

      - Para obtener el ID local del _work item_ (thread):
        ```glsl uvec3 lId = gl_LocalInvocationID```

      - Para obtener el ID global del _work item_ (thread):
        ```glsl uvec3 gId = gl_GlobalInvocationID```
    ],
  )
]

== Shader Storage Buffer Object
#slide[
  #set text(size: 16pt)
  - Introducido junto a los Compute Shaders.
  - Sirve para almacenar datos arbitrarios en un buffer en la GPU.
  - Se inicializa de la misma manera que cualquier buffer:
    ```cpp
    unsigned int ssbo;
    glGenBuffers(1, &ssbo);
    glBindBuffer(GL_SHADER_STORAGE_BUFFER, ssbo);
    glBufferData(GL_SHADER_STORAGE_BUFFER, sizeof(data), data, GL_DYNAMIC_DRAW);
    ```
  - Además de bindear a OpenGL, se debe bindear al _layout_ del shader:
    ```cpp
    glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 0, ssbo);
    // Donde 0 es el binding dentro del layout del shader
    ```
]

== Shader Storage Buffer Object
#slide[
  #set text(size: 16pt)
  - Introducido junto a los Compute Shaders.
  - También podemos acceder al buffer dentro de otros shaders.
  - Ejemplo:

  #text(size: 12pt)[
    ```glsl
    #version 430 core
    // in y out...

    // ssbo
    layout (std430, binding = 0) buffer dataBuff {
      float data[];
    };

    // uniforms...

    void main() {
      float x = data[3*gl_VertexID];
      float y = data[3*gl_VertexID+1];
      float z = data[3*gl_VertexID+2];
      gl_Position = vec4(x, y, z, 1.0f); // sin vbo!!!!
    }
    ```
    #set align(center)
    Para acceder en el vertex shader, usamos un EBO y, aunque no lo usemos, necesitamos crear un VBO (vacío).
  ]

]

== Ejecución
#slide[
  #set text(size: 13pt)
  ```cpp
  // shader programs
  unsigned int compute;
  unsigned int render;

  // ...

  while(...) {
    glUseProgram(compute);
    glBindBuffer(GL_SHADER_STORAGE, ssbo);
    glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 0, ssbo);
    // ejecucion
    glDispatchCompute(globalX, globalY, globalZ); // num de workgroups

    // sincronizacion
    glMemoryBarrier(GL_ALL_BARRIER_BITS); // podemos ser menos exigentes
    glUseProgram(render);

    // renderizado
  }

  ```
]

== Ejemplo
#focus-slide(icon: image("github-mark-white.svg"), link: "https://github.com/Seivier/NBodyCuda/tree/main")[
  en example/compute
]

= Referencias
#slide[
  #set text(size: 18pt)
  #show link: x => underline(x)
  - CUDA:

    #link("https://docs.nvidia.com/cuda/cuda-runtime-api/group__CUDART__OPENGL.html#group__CUDART__OPENGL")

  - OpenCL (macOS):

    #link("https://developer.apple.com/library/archive/documentation/Performance/Conceptual/OpenCL_MacProgGuide/shareGroups/shareGroups.html")

  - Compute Shaders:

    #link("https://learnopengl.com/Guest-Articles/2022/Compute-Shaders/Introduction")

  Para ver más shaders avanzados puede revisar el libro "OpenGL 4.0 Shading Language Cookbook".
]

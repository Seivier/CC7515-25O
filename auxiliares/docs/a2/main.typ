#import "@preview/touying:0.6.1": *
#import themes.university: *

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: "Auxiliar 2",
    subtitle: "Stencil en OpenCL",
    author: "Vicente González y Diego García",
    institution: [CC7515-1 --- Computación en GPU],
  ),
)

#title-slide()

= Introducción
== Operaciones comunes
/ Map: Aplicar una función a cada elemento de una estructura de datos. #pause

/ Reduction: Reducción a un solo valor mediante la aplicación de una operación binaria. #pause

/ Scan: Construcción de una estructura de datos acumulativa mediante la aplicación de una operación binaria. #pause

/ Search: Búsqueda de elementos en una estructura de datos #pause

/ Sort: Ordenación de elementos de una estructura de datos #pause

/ Stencil: Aplicación de un operador local a cada elemento de una estructura de datos en función de su vecindario #pause

= Stencil
== La técnica Stencil
- Es una técnica de programación que se utiliza para procesamiento de imágenes,
  simulaciones de fluidos, entre otras aplicaciones. #pause

- Se basa en actualizar cada punto de una imagen o conjunto de datos en función de
  los valores de sus vecinos cercanos. #pause

- CUDA y OpenCL son frameworks que permiten implementar esta técnica de manera
  paralela. #pause

- Al utilizar la técnica de stencil en paralelo, se pueden obtener mejoras
  significativas en el rendimiento y tiempo de procesamiento de las aplicaciones
  que la utilizan.

== Ejemplo
#align(center + top)[
  #box(image("stencil_pajaro.png", height: 100%))
]
---

Una convolución es un buen ejemplo de un Stencil. #pause
- Aplicaremos la técnica de stencil para suavizar una imagen. #pause
- El stencil se define de la siguiente manera:
#align(center)[
  $
    mat(
        1 slash 9, 1 slash 9, 1 slash 9;1 slash 9, 1 slash 9, 1 slash 9;1 slash 9, 1 slash 9, 1 slash 9;
      )
  $
] #pause
- Se aplica iterativamente en cada punto de la imagen. #pause

- Al utilizar CUDA u OpenCL para implementar esta técnica de manera paralela, se
  pueden obtener mejoras significativas en el rendimiento y tiempo de
  procesamiento de la imagen.

---

- Por ejemplo, si el stencil se coloca en el siguiente píxel:
  #align(
    center,
    stack(
      dir: ltr,
      spacing: 3em,
    )[
      #set text(size: .65em)
      $
        mat(
          1 slash 9, 1 slash 9, 1 slash 9;1 slash 9, 1 slash 9, 1 slash 9;1 slash 9, 1 slash 9, 1 slash 9;
        )
      $
    ][
      #set text(size: .65em)
      #set math.mat(delim: none)
      $ mat(1, 2, 3;4, X, 5;6, 7, 8;) $
    ],
  )
- La operación de suavizado para ese píxel sería:
  #align(center)[
    #set text(size: .65em)
    $(1 slash 9 dot 1) + (1 slash 9 dot 2) + (1 slash 9 dot 3) + (1 slash 9 dot 4) + (1 slash 9 dot X ) + (1 slash 9 dot 6)+ (1 slash 9 dot 7) + (1 slash 9 dot 8) + (1 slash 9 dot 9) \
      = (X + 1 + 2 + 3 + 4 + 6 + 7 + 8 + 9) slash 9$
  ]
- El resultado de esta operación es el nuevo valor del píxel $X$ actual después de aplicar la operación de suavizado.
- Este proceso se repite para cada píxel de la imagen, utilizando el stencil para
  calcular el nuevo valor de cada píxel en función de los valores de sus vecinos
  cercanos.

= Implementación
== Proyecto
#place(center + horizon)[
  #set text(font: "JetBrainsMono NF")
  #box(
    stack(
      dir: ltr,
      box(
        height: 2em,
        fill: rgb("#8250DF"),
        inset: .2cm,
        radius: (left: .2cm),
        image("github-mark-white.svg"),
      ),
      box(
        inset: .2cm,
        radius: (right: .2cm),
        height: 2em,
        fill: color.luma(230),
        link("https://github.com/Seivier/StencilCL"),
      ),
    ),
  )
]

#align(
  center + bottom,
  text("(pauta en rama reference)"),
)
// ]
= Experimentos
== Recomendaciones
+ Calcular el tiempo de las distintas etapas por separado #pause
  - Generación de datos aleatorios #pause
  - Copia de datos de host a device #pause
  - Ejecución del kernel #pause
  - Copia de datos de device a host #pause
  - Tiempo total de toda la operación #pause

+ Correr experimento más de una vez (5-10) #pause

+ Para calcular el speed-up:

#align(center)[$s="tGPU" / "tCPU"$]
---
#align(center)[
  #set text(size: .8em)
  #stack(
    dir: ltr,
    spacing: 3em,
    figure(image("speedup-ruido.png", height: 70%), caption: "Un solo experimento"),
    figure(image("speedup.png", height: 70%), caption: "Promedio de 5 experimentos"),
  )
]

= Referencias
==

// #slide[

//   #set text(size: .7em)
// #show link: set text(fill: rp-colors.foam, size: .8em)
- Blog de Nvidia

  #link("https://developer.nvidia.com/blog/using-shared-memory-cuda-cc/")

- Presentación de Nvidia

  #link("https://www.nvidia.com/docs/IO/116711/sc11-cuda-c-basics.pdf")

- Experimentos GPolylla:

  #link("https://github.com/ssalinasfe/GPolylla/tree/main/experiments")

- Presentación de Sergio:

  #link("https://www.u-cursos.cl/ingenieria/2023/1/CC7515/1/material_docente/bajar?bajar=1&id=6539157")
// ]

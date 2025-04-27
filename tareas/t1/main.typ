#let code(filename, lang) = {
  set raw(lang: "cpp")
  show raw: x => block(width: 100%, fill: luma(250), inset: 10pt, radius: 5pt, text(font: "JetBrains Mono", x))
  show figure: set block(breakable: true)
  let src = read(filename)
  figure(
    align(left, raw(src)),
    caption: [Archivo #filename],
  )
}

#let conf(title: "", body) = context {
  set text(font: "New Computer Modern", size: 11pt, lang: "es")
  set figure.caption(position: top)
  set heading(numbering: "1.  ")
  set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
  set text(font: "New Computer Modern")
  show raw: set text(font: "JetBrains Mono")
  // show par: set block(spacing: 0.55em)
  set par(spacing: 0.55em)
  show heading: set block(above: 1.4em, below: 1em)
  show link: x => text(fill: blue, underline(x))
  let header = [
    #set text(size: 10pt)
    #let info = stack(
      dir: ttb,
      spacing: 5pt,
      "Universidad de Chile",
      "Facultad de Ciencias Físicas y Matemáticas",
      "Departamento de Ciencias de la Computación",
      "CC7515-1 " + sym.dash.em + " Computación en GPU",
    )
    #context stack(dir: ltr, info, h(1fr), image("dcc.svg", height: measure(info).height))
    // #v(-5pt)
    #line(length: 100%, stroke: .5pt)
  ]
  let footer = context [
    #set text(10pt)
    #line(length: 100%, stroke: .5pt)
    // #v(-5pt)
    #stack(dir: ltr, text(title, style: "italic"), h(1fr), counter(page).display("1"))
  ]

  let headerSize = measure(header).height
  let footerSize = measure(footer).height
  set page(
    margin: (top: .5in + headerSize + 20pt, left: 1in, right: 1in, bottom: .5in + footerSize + 20pt),
    header: header,
    footer: footer,
  )
  align(
    center,
    stack(
      dir: ttb,
      spacing: 5pt,
      text(size: 24pt, title),
      v(20pt),
      "Profesora: Nancy Hitschfeld K.",
      "Auxiliares: Diego García y Vicente González",
    ),
  )
  body
}
#show: conf.with(title: [Tarea 1 -- Repaso C++])
= Introducción
Esta tarea inicial está orientada para los que no han aún programado en C++ den los primeros pasos en esa dirección y para los que ya saben, repasar las características más importantes, e implementar en C++ una clase que permita manejar matrices como lo hace Matlab/Octave, aunque una versión reducida.

= Requerimientos de la tarea

Se debe implementar la clase *Matrix* la cual aceptará el tipo de dato `double` y deberá realizar múltiples operaciones, como lo son:

#block(
  height: 7em,
  columns(2)[
    - Suma

    - Resta

    - Multiplicación

    - Obtener el máximo/mínimo

    - Cálculo de la transpuesta

    - Guardar la matriz a un archivo

    - Crear una matriz desde un archivo

    - Imprimir en consola

    - Construir matriz a través de la consola
  ],
)

Se le proveerá un archivo .h con las declaraciones de la clase. Usted debe implementar todos los
métodos, los cuales deben ser testeados con #link("https://github.com/google/googletest")[Google Test] (como se vió en la auxiliar 2). El objetivo de
la tarea es familiarizarse con el lenguaje de programación, la creación de objetos, el cálculo matricial
y el testing. La clase debe tener como mínimo lo siguiente:

#code("Matrix.h", "cpp")

Ejemplo de uso:

#code("example.cpp", "cpp")
Algunas consideraciones:

- El constructor debe inicializar la matriz en cero.

- Los índices de filas y columnas parten desde cero.

- Se espera un test de cada una de las operaciones, pruebe multiplicación, sumas y restas con distintos tamaños de la matriz, etc. Las funciones que imprimen en pantalla no son necesarias testearlas.

- Si se realiza una operación incorrecta (como multiplicar matrices con incorrecto orden) se espera que usted lance una excepción. Para ello puede usar `throw std::logic_error("[MATRIX] Mensaje de error");`.
  Los tests también deben ser capaces de esperar excepciones.

- Usted puede añadir tantos métodos privados como estime conveniente, puede incluso cambiar los nombres de las variables privadas.
  Lo que NO puede hacer es renombrar las operaciones *públicas* ya que su código será testeado con un archivo externo.

- Usted debe crear una *librería* no un *ejecutable*, ya que la idea es que su código sea usado por otras personas.

- Para que su tarea compile debe utilizar el *estándar C++ 11* en adelante, esto lo puede definir dentro de cmake cambiando la variable `CMAKE_CXX_STANDARD`.

En el readme conteste las siguientes preguntas:

+ ¿Afectaría en algo el tipo de dato de su matriz?, ¿Qué pasa si realiza operaciones de multiplicación tipo de dato _integer_ en vez de _double_?

+ Si se empezaran a usar números muy pequeños o muy grandes y principalmente números primos, ¿Qué ocurre en términos de precisión?

+ ¿Pueden haber problemas de precisión si se comparan dos matrices idénticas pero con diferente tipo? (`Matrix p1 == p2`).

// + Grafique el tiempo que tarda el proceso de inversión de la matriz vs el número de elementos (tamaño) y comente sus resultados.


= Información extra
- *Se debe incluir README sobre cómo ejecutar su programa.* Si no se incluye un README se realizará 1.0 punto de descuento en su tarea.

- Su tarea debe realizarse con tests. Se evaluará que cada una de sus implementaciones haya sido testeada. Tareas sin tests serán evaluadas con la nota mínima.

- No modifique el nombre de las funciones, ya que la evaluación de la tarea se hará con un archivo de test que llamará a las mismas funciones que posee el archivo de encabezado .h. Tampoco puede cambiar el nombre de la clase.

- Se recomienda la utilización del IDE CLion de Jetbrains, ya que al ser estudiantes de la Universidad de Chile disponen de cuentas profesionales gratuitas.
  Para esto deben ingresar a https://www.jetbrains.com/shop/eform/students y utilizando su correo \@dcc.uchile.cl deberían recibir de forma casi instantánea la aprobación.
  CLion funciona tanto en Unix como en Windows (ahí deberán instalar primero MinWin o CygWin y CLion lo reconocerá).
  A menos que usted haga uso intenso de Visual Studio, este no se recomienda tanto por la dificultad de la curva de aprendizaje así como también el uso en espacio (pesa alrededor de 30GB).


- La fecha de entrega es aquella que salga en U-Cursos.

= Links de interés

- #link("https://www.jetbrains.com/es-es/clion/")[Editor CLion para C++]

- #link("https://www.geeksforgeeks.org/c-plus-plus/")[Tutorial C++ (1)]

- #link("https://conclase.net/c/curso/cap29")[Curso de C++ (2)]

- #link("https://www.geeksforgeeks.org/copy-constructor-in-cpp/")[Copy constructor in C++]

- #link("https://en.cppreference.com/w/cpp/language/operators")[Operator overloading]

// - #link("")[What is “Object-Oriented Programming”? (1991 revised version)]

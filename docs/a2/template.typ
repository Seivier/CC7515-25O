#import "@preview/polylux:0.3.1": *

#let aux = (number: state("n", 0), course: state("c", []), title: state("t", []))
#let rp-colors = (
  base: rgb("#191724"), surface: rgb("#1f1d2e"), overlay: rgb("#26233a"), muted: rgb("#6e6a86"), subtle: rgb("#908caa"), text: rgb("#e0def4"), love: rgb("#eb6f92"), gold: rgb("#f6c177"), rose: rgb("#ebbcba"), pine: rgb("#31748f"), foam: rgb("#9ccfd8"), iris: rgb("#c4a7e7"), hl-low: rgb("#21202e"), hl-med: rgb("#403d52"), hl-high: rgb("#524f67"),
)

#let rp-theme(aspect-ratio: "16-9", body) = {
  set text(fill: rp-colors.text, size: 30pt, font: "Ubuntu")
  let background = {
    let p = pattern(
      box(
        inset: (top: 2pt), fill: rp-colors.base, text(fill: rp-colors.overlay, font: "Fira Code", size: 10pt, "10"),
      ),
    )
    rect(fill: p, width: 100%, height: 100%)
    place(top)[
      #rect(fill: rp-colors.overlay, width: 100%, height: 3cm)
    ]
    place(bottom)[
      #rect(fill: rp-colors.overlay, width: 100%, height: 3cm)
    ]
  }
  set page(
    paper: "presentation-" + aspect-ratio, background: background, margin: .5cm,
  )

  show raw: set text(font: "Fira Code")
  body
}

#let alert(content) = text(fill: rp-colors.love, content)

#let title-slide(number: 0, title: [], course: []) = {
  aux.number.update(number)
  aux.course.update(course)
  aux.title.update(title)
  polylux-slide(
    {
      set align(center + horizon)
      text(fill: rp-colors.rose, size: 2em, raw("Auxiliar #" + str(number)))
      v(-1em)
      text(
        fill: rp-colors.gold, weight: "bold", font: "Montserrat", size: 2.5em, title,
      )
      place(
        top + right,
      )[
        #set align(right)
        #set text(size: 10pt)
        #stack(
          dir: ttb, spacing: 1em, "Universidad de Chile", "Facultad de Ciencias Físicas y Matemáticas", "Departamento de Ciencias de la Computación", course,
        )
      ]
      place(
        bottom + left,
      )[
        #set text(size: 14pt)
        #stack(
          dir: ttb, spacing: 1em, "Profesor: Nancy Hitschfeld", "Auxiliar: Vicente González", datetime.today().display("[day] / [month] / [year]"),
        )
      ]
    },
  )
}

#let section-slide(content) = {
  set page(fill: rp-colors.hl-low, background: [])
  utils.register-section(content)
  polylux-slide(
    {
      set align(left + horizon)
      box(
        inset: 1cm,
      )[
        #set text(fill: rp-colors.rose, font: "Fira Code")
        \~/#context aux.course.get()/Aux#context aux.number.get()
        #set text(fill: rp-colors.text, font: "Montserrat", size: 2em)
        #v(-.5em)
        #box(
          fill: rp-colors.hl-low, width: 100%, height: 2em, stack(
            dir: ltr, spacing: 1em, text(font: "JetBrains Mono", ">"), underline(strong(content)),
          ),
        )
      ]
    },
  )
}
#let slide(title: [], content) = {
  let background = {
    let p = pattern(
      box(
        inset: (top: 2pt), fill: rp-colors.base, text(fill: rp-colors.overlay, font: "JetBrains Mono", size: 10pt, "10"),
      ),
    )
    rect(fill: p, width: 100%, height: 100%)
  }
  set page(background: background)
  polylux-slide(
    {
      // set align(center + horizon)
      align(
        center + horizon, box(
          width: 90%, height: 90%, inset: 1cm, radius: .2cm, fill: rp-colors.overlay,
        )[
          #set align(left)
          #if title != [] {
            align(
              center + top, text(font: "Montserrat", weight: "bold", size: 1.5em, title),
            )
          }
          #content
        ],
      )
      place(
        top + right, box(
          inset: .5cm, box(
            fill: rp-colors.pine, inset: .2cm, radius: .1cm, text(size: 16pt, utils.current-section),
          ),
        ),
      )
    },
  )
}


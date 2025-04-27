// University theme

// Originally contributed by Pol Dellaiera - https://github.com/drupol

#import "@preview/touying:0.6.1": *

/// Default slide function for the presentation.
///
/// - config (dictionary): is the configuration of the slide. Use `config-xxx` to set individual configurations for the slide. To apply multiple configurations, use `utils.merge-dicts` to combine them.
///
/// - repeat (int, auto): is the number of subslides. The default is `auto`, allowing touying to automatically calculate the number of subslides. The `repeat` argument is required when using `#slide(repeat: 3, self => [ .. ])` style code to create a slide, as touying cannot automatically detect callback-style `uncover` and `only`.
///
/// - setting (dictionary): is the setting of the slide, which can be used to apply set/show rules for the slide.
///
/// - composer (array, function): is the layout composer of the slide, allowing you to define the slide layout.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]` will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - bodies (arguments): is the contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  align: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = {
    set std.align(right)
    block(
      inset: (right: 3em),
      box(
        inset: .2cm,
        radius: (top: .1cm),
        fill: self.colors.pine,
        text(size: 16pt, fill: self.colors.text, self.store.section),
      ),
    )
    // box(
    //   inset: .5cm,
    //   box(
    //     fill: self.colors.pine,
    //     inset: .2cm,
    //     radius: .1cm,
    //     // text(size: 16pt, self.store.header),
    //     [Hola],
    //   ),
    // )

    // grid(
    //   rows: (auto, auto),
    //   row-gutter: 3mm,
    //   block(
    //     inset: (x: .5em),
    //     components.left-and-right(
    //       // text(fill: self.colors.primary, weight: "bold", size: 1.2em, utils.call-or-display(self, self.store.header)),
    //       [],
    //       text(fill: self.colors.primary.lighten(65%), utils.call-or-display(self, self.store.header-right)),
    //     ),
    //   ),
    // )
  }

  let self = utils.merge-dicts(
    self,
    config-page(
      background: utils.call-or-display(self, self.store.background),
      header: header,
    ),
  )
  let new-setting = body => {
    show: setting
    std.align(
      center + horizon,
      box(
        width: 100%,
        height: 100%,
        inset: 1cm,
        radius: .5cm,
        fill: self.colors.overlay,
      )[
        #set std.align(left)
        #self.store.header
        #body
      ],
    )
  }

  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})


/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: university-theme.with(
///   config-info(
///     title: [Title],
///     logo: emoji.school,
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle])
/// ```
///
/// - config (dictionary): is the configuration of the slide. Use `config-xxx` to set individual configurations for the slide. To apply multiple configurations, use `utils.merge-dicts` to combine them.
///
/// - extra (string, none): is the extra information for the slide. This can be passed to the `title-slide` function to display additional information on the title slide.
#let title-slide(
  config: (:),
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    config-page(background: utils.call-or-display(self, self.store.background), margin: 0em),
  )
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }

  let a-heading = if info.authors.len() > 1 {
    "Auxiliares: "
  } else {
    "Auxiliar: "
  }

  info.professors = {
    let professors = if "professors" in info {
      info.professors
    } else {
      info.professor
    }
    if type(professors) == array {
      professors
    } else {
      (professors,)
    }
  }

  let p-heading = if info.professors.len() > 1 {
    "Profesores: "
  } else {
    "Profesor: "
  }

  let body = {
    // set align(center + horizon)
    stack(
      spacing: 1fr,
      {
        set text(size: 10pt)
        block(
          fill: self.colors.overlay,
          width: 100%,
          inset: 1em,
          align(
            right,
            stack(
              spacing: 1em,
              "Universidad de Chile",
              "Facultad de Ciencias Físicas y Matemáticas",
              "Departamento de Ciencias de la Computación",
              info.course,
            ),
          ),
        )
      },
      align(
        center,
        block(
          width: 100%,
          stack(
            spacing: 1em,
            text(fill: self.colors.rose, size: 2em, raw("Auxiliar #" + str(info.number))),
            text(
              fill: self.colors.gold,
              weight: "bold",
              font: "Reddit Sans",
              size: 2.5em,
              info.title,
            ),
          ),
        ),
      ),
      {
        set text(size: 14pt)
        block(
          width: 100%,
          inset: 1em,
          fill: self.colors.overlay,
          stack(
            dir: ttb,
            spacing: 1em,
            p-heading + info.professors.join(", ", last: " y "),
            a-heading + info.authors.join(", ", last: " y "),
            info.date,
          ),
        )
      },
    )
    // place(top + right)[
    //   #set align(right)
    //   #set text(size: 10pt)
    //   #stack(
    //     dir: ttb,
    //     spacing: 1em,
    //     "Universidad de Chile",
    //     "Facultad de Ciencias Físicas y Matemáticas",
    //     "Departamento de Ciencias de la Computación",
    //     info.course,
    //   )
    // ]
    // place(bottom + left)[
    //   #set text(size: 14pt)
    //   #stack(
    //     dir: ttb,
    //     spacing: 1em,
    //     "Profesor: " + info.professors.join(", ", last: " y "),
    //     "Auxiliar: " + info.authors.join(", ", last: " y "),
    //     info.date,
    //   )
    // ]
  }

  // let body = {
  //   if info.logo != none {
  //     place(right, text(fill: self.colors.primary, info.logo))
  //   }
  //   std.align(
  //     center + horizon,
  //     {
  //       block(
  //         inset: 0em,
  //         breakable: false,
  //         {
  //           text(size: 2em, fill: self.colors.primary, strong(info.title))
  //           if info.subtitle != none {
  //             parbreak()
  //             text(size: 1.2em, fill: self.colors.primary, info.subtitle)
  //           }
  //         },
  //       )
  //       set text(size: .8em)
  //       grid(
  //         columns: (1fr,) * calc.min(info.authors.len(), 3),
  //         column-gutter: 1em,
  //         row-gutter: 1em,
  //         ..info.authors.map(author => text(fill: self.colors.neutral-darkest, author))
  //       )
  //       v(1em)
  //       if info.institution != none {
  //         parbreak()
  //         text(size: .9em, info.institution)
  //       }
  //       if info.date != none {
  //         parbreak()
  //         text(size: .8em, utils.display-info-date(self))
  //       }
  //     },
  //   )
  // }
  touying-slide(self: self, body)
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - config (dictionary): is the configuration of the slide. Use `config-xxx` to set individual configurations for the slide. To apply multiple configurations, use `utils.merge-dicts` to combine them.
///
/// - level (int, none): is the level of the heading.
///
/// - numbered (boolean): is whether the heading is numbered.
///
/// - body (auto): is the body of the section. This will be passed automatically by Touying.
#let new-section-slide(config: (:), level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  set page(fill: self.colors.hl-low)
  let slide-body = {
    set align(left + horizon)
    box(inset: 1cm)[
      #set text(fill: self.colors.rose, font: "Monaspace Neon")
      \~/#self.info.course/Aux#self.info.number
      #set text(fill: self.colors.text, font: "Reddit Sans", size: 2em)
      // #v(-.5em)
      #box(
        fill: self.colors.hl-low,
        width: 100%,
        height: 1em,
        stack(
          dir: ltr,
          spacing: 1em,
          text(font: "Monaspace Neon", ">"),
          text(fill: self.colors.text, underline(utils.display-current-heading(level: level, numbered: numbered))),
        ),
      )
    ]
    body
  }
  // let slide-body = {
  //   set std.align(horizon)
  //   show: pad.with(20%)
  //   set text(size: 1.5em, fill: self.colors.primary, weight: "bold")
  //   stack(
  //     dir: ttb,
  //     spacing: .65em,
  //     utils.display-current-heading(level: level, numbered: numbered),
  //     block(
  //       height: 2pt,
  //       width: 100%,
  //       spacing: 0pt,
  //       components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
  //     ),
  //   )
  //   body
  // }
  touying-slide(self: self, config: config, slide-body)
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - config (dictionary): is the configuration of the slide. Use `config-xxx` to set individual configurations for the slide. To apply multiple configurations, use `utils.merge-dicts` to combine them.
///
/// - background-color (color, none): is the background color of the slide. Default is the primary color.
///
/// - background-img (string, none): is the background image of the slide. Default is none.
#let focus-slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  align: auto,
  link: "",
  icon: none,
  body,
) = touying-slide-wrapper(self => {
  let header(self) = {
    set std.align(right)
    block(
      inset: (right: 3em),
      box(
        inset: .2cm,
        radius: (top: .1cm),
        fill: self.colors.pine,
        text(size: 16pt, fill: self.colors.text, self.store.section),
      ),
    )
  }

  let self = utils.merge-dicts(
    self,
    config-page(
      background: utils.call-or-display(self, self.store.background),
      header: header,
    ),
  )
  let new-setting = body => {
    show: setting
    std.align(
      center + horizon,
      box(
        width: 100%,
        height: 100%,
        inset: 1cm,
        radius: .5cm,
        fill: self.colors.overlay,
      )[
        #self.store.header

        #set std.align(center + horizon)
        #set text(font: "Monaspace Neon", fill: self.colors.hl-low, size: 20pt)
        #let button = {
          if icon != none {
            box(
              stack(
                dir: ltr,
                box(
                  height: 2em,
                  fill: self.colors.surface,
                  inset: .2cm,
                  radius: (left: .2cm),
                  icon,
                ),
                box(
                  inset: .2cm,
                  radius: (right: .2cm),
                  height: 2em,
                  fill: self.colors.iris,
                  std.align(horizon, link),
                ),
              ),
            )
          } else {
            box(
              inset: (y: .2cm, x: .5cm),
              radius: .2cm,
              height: 2em,
              fill: self.colors.iris,
              std.align(horizon, link),
            )
          }
        }


        #stack(
          spacing: 1em,
          button,
          text(fill: self.colors.text, body),
        )
      ],
    )
  }

  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, body)
})


// Create a slide where the provided content blocks are displayed in a grid and coloured in a checkerboard pattern without further decoration. You can configure the grid using the rows and `columns` keyword arguments (both default to none). It is determined in the following way:
///
/// - If `columns` is an integer, create that many columns of width `1fr`.
/// - If `columns` is `none`, create as many columns of width `1fr` as there are content blocks.
/// - Otherwise assume that `columns` is an array of widths already, use that.
/// - If `rows` is an integer, create that many rows of height `1fr`.
/// - If `rows` is `none`, create that many rows of height `1fr` as are needed given the number of co/ -ntent blocks and columns.
/// - Otherwise assume that `rows` is an array of heights already, use that.
/// - Check that there are enough rows and columns to fit in all the content blocks.
///
/// That means that `#matrix-slide[...][...]` stacks horizontally and `#matrix-slide(columns: 1)[...][...]` stacks vertically.
///
/// - config (dictionary): is the configuration of the slide. Use `config-xxx` to set individual configurations for the slide. To apply multiple configurations, use `utils.merge-dicts` to combine them.
#let matrix-slide(config: (:), columns: none, rows: none, ..bodies) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )
  touying-slide(
    self: self,
    config: config,
    composer: components.checkerboard.with(columns: columns, rows: rows),
    ..bodies,
  )
})


/// Touying university theme.
///
/// Example:
///
/// ```typst
/// #show: university-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// The default colors:
///
/// ```typ
/// config-colors(
///   primary: rgb("#04364A"),
///   secondary: rgb("#176B87"),
///   tertiary: rgb("#448C95"),
///   neutral-lightest: rgb("#ffffff"),
///   neutral-darkest: rgb("#000000"),
/// )
/// ```
///
/// - aspect-ratio (string): is the aspect ratio of the slides. Default is `16-9`.
///
/// - align (alignment): is the alignment of the slides. Default is `top`.
///
/// - progress-bar (boolean): is whether to show the progress bar. Default is `true`.
///
/// - header (content, function): is the header of the slides. Default is `utils.display-current-heading(level: 2)`.
///
/// - header-right (content, function): is the right part of the header. Default is `self.info.logo`.
///
/// - footer-columns (tuple): is the columns of the footer. Default is `(25%, 1fr, 25%)`.
///
/// - footer-a (content, function): is the left part of the footer. Default is `self.info.author`.
///
/// - footer-b (content, function): is the middle part of the footer. Default is `self.info.short-title` or `self.info.title`.
///
/// - footer-c (content, function): is the right part of the footer. Default is `self => h(1fr) + utils.display-info-date(self) + h(1fr) + context utils.slide-counter.display() + " / " + utils.last-slide-number + h(1fr)`.
#let rp-theme(
  aspect-ratio: "16-9",
  number: 0,
  course: "",
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      header-ascent: 0em,
      footer-descent: 0em,
      margin: 1.5em,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(size: 22pt, font: "Reddit Sans", fill: self.colors.text)

        show heading.where(level: 2): x => std.align(
          center + top,
          text(fill: self.colors.rose, size: 2em, weight: "bold", x),
        )

        show raw: x => text(
          font: "Monaspace Neon",
          align(center, block(fill: self.colors.base, inset: 10pt, radius: 5pt, x)),
        )
        show emph: set text(fill: self.colors.gold)
        body
      },
      alert: (self: none, body) => text(fill: self.colors.love, body),
    ),
    config-colors(
      base: rgb("#191724"),
      surface: rgb("#1f1d2e"),
      overlay: rgb("#26233a"),
      muted: rgb("#6e6a86"),
      subtle: rgb("#908caa"),
      text: rgb("#e0def4"),
      love: rgb("#eb6f92"),
      gold: rgb("#f6c177"),
      rose: rgb("#ebbcba"),
      pine: rgb("#31748f"),
      foam: rgb("#9ccfd8"),
      iris: rgb("#c4a7e7"),
      hl-low: rgb("#21202e"),
      hl-med: rgb("#403d52"),
      hl-high: rgb("#524f67"),
    ),
    // save the variables for later use
    config-store(
      header: utils.display-current-heading(level: 2, style: auto),
      section: utils.display-current-heading(level: 1),
      background: self => {
        let p = tiling(
          box(
            inset: (top: 2pt),
            fill: self.colors.base,
            text(fill: self.colors.overlay, font: "Monaspace Neon", size: 10pt, "10"),
          ),
        )
        rect(fill: p, width: 100%, height: 100%)
      },
    ),
    ..args,
  )

  body
}

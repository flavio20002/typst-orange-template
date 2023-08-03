#import("my-outline.typ"): *

#let normalText = 1em
#let largeText = 3em
#let hugeText = 16em
#let title_main_1 = 2.5em
#let title_main_2 = 1.8em
#let title_main_3 = 2.2em
#let title1 = 2.2em
#let title2 = 1.5em
#let title3 = 1.3em
#let title4 = 1.2em
#let title5 = 1.1em


#let nocite(citation) = {
  place(hide[#cite(citation)])
}

#let actual_figure = figure

#let figure(..args, label:none) = {
  locate(loc => {
      let chapter = counter(heading.where(level: 1)).at(loc).first()
      set actual_figure(numbering: it => box[#chapter.#it])
      [
        #actual_figure(..args)
        #label
      ]
    }
  )
}

#let appendix_state = state("appendix_state", none)
#let heading_image = state("heading_image", none)
#let part_state = state("part_state", none)
#let part_location = state("part_location", none)
#let part_counter = counter("part_counter")
#let part_change = state("part_change", false)


// pagebreak(to: "odd") is not working correctly
#let pagebreak_until_odd() = {
  pagebreak()
  counter(page).display(i => if calc.even(i) {
    pagebreak()
  })
}

#let part(title, mainColor) = {
  pagebreak(to: "odd")
  part_change.update(x =>
    true
  )
  part_state.update(x =>
    title
  )
  part_counter.step()
  [
    #locate(loc => [
      #part_location.update(x =>
        loc
      )
    ])
    #[
    #set par(justify: false)
    #place(block(width:100%, height:100%, outset: (x: 3cm, bottom: 2.5cm, top: 3cm), fill: mainColor.lighten(70%)))
    #place(top+right, text(fill: black, size: largeText, weight: "bold", box(width: 60%, part_state.display())))
    #place(top+left, text(fill: mainColor, size: hugeText, weight: "bold", part_counter.display("I")))
    ]
    #align(bottom+right, my-outline-small(title, appendix_state, part_state, part_location,part_change,part_counter, mainColor, textSize1: title2, textSize2: title3, textSize3: normalText, textSize4: normalText))
  ]
}

#let chapter(title, image:none, resetHeading: none) = {
  pagebreak(to: "odd")
  heading_image.update(x =>
    image
  )
  if (resetHeading!=none){
    counter(heading).update(0)
    heading(level:1, title, numbering: none )
  }
  else{
    heading(level:1, title )
  }
  part_change.update(x =>
    false
  )
}

#let appendices(title, doc) = {
  counter(heading).update(0)
  appendix_state.update(x =>
    title
  )
  set heading ( numbering: (..nums) => {
      let vals = nums.pos()
      if vals.len() == 1 {
        return str(numbering("A.1", ..vals)) + "."
      }
      else {
        return numbering("A.1", ..vals)
      }
    },
  )
  doc
}

#let my-bibliography(file, image:none) = {
  pagebreak_until_odd()
  counter(heading).update(0)
  heading_image.update(x =>
    image
  )
  file
}

#let project(title: "", subtitle: "", date: "", author: (), logo: none, cover: none, imageIndex:none, body, mainColor: blue,copyright: [], lang: "en", listOfFigureTitle: none, listOfTableTitle: none, supplementChapter: "Chapter", fontSize: 10pt) = {
  set document(author: author, title: title)
  set text(size: normalText, lang: lang)
  set par(leading: 0.5em)

  set page(
    paper: "a4",
    margin: (x: 3cm, bottom: 2.5cm, top: 3cm),
     header: locate(loc => {
      set text(size: title5)
      let page_number = counter(page).at(loc).first()
      let odd_page = calc.odd(page_number)
      // Are we on an odd page?
      // if odd_page {
      //   return text(0.95em, smallcaps(title))
      // }

      // Are we on a page that starts a chapter? (We also check
      // the previous page because some headings contain pagebreaks.)
      let all = query(heading.where(level: 1), loc)
      if all.any(it => it.location().page() == page_number) {
        return
      }
      let appendix = appendix_state.at(loc)      
      if odd_page {
        let before = query(selector(heading.where(level: 2)).before(loc), loc)
        let counterInt = counter(heading).at(loc)
        if before != () and counterInt.len()> 2 {
          box(width: 100%, inset: (bottom: 5pt), stroke: (bottom: 0.5pt))[
            #text(if appendix != none {numbering("A.1", ..counterInt.slice(1,3)) + " " + before.last().body} else {numbering("1.1", ..counterInt.slice(1,3)) + " " + before.last().body})
            #h(1fr)
            #page_number
          ]
        }
      } else{
        let before = query(selector(heading.where(level: 1)).before(loc), loc)
        let counterInt = counter(heading).at(loc).first()
        if before != () and counterInt > 0 {
          box(width: 100%, inset: (bottom: 5pt), stroke: (bottom: 0.5pt))[
            #page_number
            #h(1fr)
            #text(weight: "bold", if appendix != none {numbering("A.1", counterInt) + ". " + before.last().body} else{before.last().supplement + " " + str(counterInt) + ". " + before.last().body})
          ]
        }
      }
    })
  )

  set heading(
    numbering: (..nums) => {
      let vals = nums.pos()
      if vals.len() == 1 {
        return str(vals.first()) + "."
      }
      else {
        return nums.pos().map(str).join(".")
      }
    },
    supplement: supplementChapter
  );

  set list(tight:true, indent: 0.15cm ,body-indent: 0.4cm, marker: (place(center, dy: -0.12cm, text(size: 1.5em, fill: mainColor, "▶")), place(center, dy: 0.09cm, text(size: 0.6em, fill: mainColor, "◼"))))

  show list: it  => {
    parbreak()
    it
  }

  show heading: it => {
    set text(size: fontSize)
    if it.level == 1 {
      //set par(justify: false)
      counter(actual_figure.where(kind: image)).update(0)
      locate(loc => {
        let img = heading_image.at(loc)
        if img != none {
          set image(width: 21cm, height: 9.4cm)
          place(move(dx: -3cm, dy: -3cm, img))
          place( move(dx: -3cm, dy: -3cm, block(width: 21cm, height: 9.4cm, align(right + bottom, pad(bottom: 1.2cm, block(
            width: 86%,
            stroke: (
                right: none,
                rest: 2pt + mainColor,
            ),
            inset: (left:2em, rest: 1.6em),
            fill: white,
            radius: (
                right: 0pt,
                left: 10pt,
            ),
            align(left, text(size: title1, it))
          ))))))
          v(8.4cm)
      }
      else{
        move(dx: 3cm, dy: -0.5cm, align(right + top, block(
            width: 100% + 3cm,
            stroke: (
                right: none,
                rest: 2pt + mainColor,
            ),
            inset: (left:2em, rest: 1.6em),
            fill: white,
            radius: (
                right: 0pt,
                left: 10pt,
            ),
            align(left, text(size: title1, it))
          )))
        v(1.5cm, weak: true)
      }
      })
    }
    else if it.level == 2 or it.level == 3 or it.level == 4 {
      let size
      let space
      let color = mainColor
      if it.level == 2 {
        size= title2
        space = 1em
      }
      else if it.level == 3 {
        size= title3
        space = 0.9em
      }
      else {
        size= title4
        space = 0.7em
        color = black
      }
      set text(size: size)
      locate(loc => {
      [
        #if (it.numbering!=none){
          place(dx:-4.5cm, box(width: 4cm, align(right, text(fill: color)[#counter(heading).display(it.numbering)])))
        }
        #it.body
        #v(space, weak: true)
        ]
      }
      )
    }
    else {
      parbreak()
      text(weight: "bold", it.body)
      h(0.5em)
    } 
  }

  set actual_figure(gap: 1.3em)

  show actual_figure: it => align(center)[
    #v(2.6em, weak: true)
    #it
    #v(2.6em, weak: true)
  ]

  set underline(offset: 3pt)

  //Structured text language
  show raw.where(lang: "iecst"): it => [
    #show regex("\b(VAR_GLOBAL|END_VAR|BOOL)\b") : keyword => text(weight:"bold", fill: blue, keyword)
      #show regex(";|:") : keyword => text(weight:"bold", fill: blue, keyword)
    #it
  ]

  // Title page.
  page(margin: 0cm, header: none)[
    #set text(fill: black)
    //#place(top, image("images/background2.jpg", width: 100%, height: 50%))
    #if cover != none {
      set image(width: 100%, height: 100%)
      place(bottom, cover)
    }
    #if logo != none {
        set image(width: 3cm)
        place(top + center, pad(top:1cm, logo))
    }
    #align(center + horizon, block(width: 100%, fill: mainColor.lighten(80%), height: 7.5cm, pad(x:2cm, y:1cm)[
      #par(leading: 0.4em)[
        #text(size: title_main_1, weight: "black", title)
      ]
      #v(1cm, weak: true)
      #text(size: title_main_2, subtitle)
      #v(1cm, weak: true)
      #text(size: title_main_3, weight: "bold", author)
    ]))
  ]
  if (copyright!=none){
    set text(size: 10pt)
    show link: it => [
      #set text(fill: mainColor)
      #it
    ]
    show par: set block(spacing: 2em)
    pagebreak()
    align(bottom, copyright)
  }
  
  heading_image.update(x =>
    imageIndex
  )

  my-outline(appendix_state, part_state, part_location,part_change,part_counter, mainColor, textSize1: title2, textSize2: title3, textSize3: fontSize, textSize4: fontSize)

  my-outline-sec(listOfFigureTitle, actual_figure.where(kind: image), fontSize)

  my-outline-sec(listOfTableTitle, actual_figure.where(kind: table), fontSize)


  // Main body.
  set par(justify: true)

  body

}


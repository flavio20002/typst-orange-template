#let classes = (main: "Main")
#let index_string = "my_index"

#let index(content) = place(hide(
figure(
    classes.main,
    caption: content,
    numbering: none,
    kind: index_string
)))

#let make-index(title: none, mainColor: blue) = {
    pagebreak(to: "odd")
    locate(loc => {
        let elements = query(selector(figure.where(kind: index_string)).before(loc), loc)
        let words = (:)
        for el in elements {
            let ct = ""
            ct = el.caption.text
            if words.keys().contains(ct) != true {
                words.insert(ct, ())
            }
            let ent = (class: el.body.text, page: el.location().page())
            if not words.at(ct).contains(ent){
                words.at(ct).push(ent)
            }
        }

        let sortedkeys = words.keys().sorted()

        let register = ""
        if title != none {
            heading(level: 1, numbering: none, title)
        }
        block(columns(2,gutter: 1cm, [
            #for sk in sortedkeys [
                #let formattedPageNumbers = words.at(sk).map(en => {
                    link((page: en.page, x:0pt, y:0pt), text(fill: black, str(en.page)))
                })
                    #let firstCharacter = sk.first()
                    #if firstCharacter != register {
                        v(1em, weak:true)
                        box(width: 100%, fill: mainColor.lighten(60%), inset: 5pt, align(center, text(size: 1.1em, weight: "bold", firstCharacter)))
                        register = firstCharacter
                        v(1em, weak:true)
                    }
                    #set text(size: 0.9em)
                    #if(sk.contains("!")){
                        h(2em)
                        sk.slice(sk.position("!")+1)
                    }
                    else{
                     sk
                    }
                    #box(width: 1fr, repeat(text(weight: "regular")[. #h(4pt)])) 
                    #formattedPageNumbers.join(",")
                    #v(0.65em, weak:true)
        ]
        ]))
    })
}

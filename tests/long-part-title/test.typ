#import "../../typst-orange.typ": project, part, chapter, my-bibliography, appendices

#let mainColor = rgb("#F36619")

#show: project.with(
  title: "Exploring the Physical Manifestation of Humanity’s Subconscious Desires",
  subtitle: "A Practical Guide",
  date: "Anno scolastico 2023-2024",
  author: "Goro Akechi",
  mainColor: mainColor,
  lang: "en",
  cover: image("./background.png"),
  imageIndex: image("./orange1.jpg"),
  listOfFigureTitle: "List of Figures",
  listOfTableTitle: "List of Tables",
  supplementChapter: "Chapter",
  copyright: [
    Copyright © 2023 Flavio Barisi

    PUBLISHED BY PUBLISHER

    #link("https://github.com/flavio20002/typst-orange-template", "TEMPLATE-WEBSITE")

    Licensed under the Apache 2.0 License (the “License”).
    You may not use this file except in compliance with the License. You may obtain a copy of
    the License at https://www.apache.org/licenses/LICENSE-2.0. Unless required by
    applicable law or agreed to in writing, software distributed under the License is distributed on an
    “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.

    _First printing, July 2023_
  ]
)

#part("This is a very long part title to test the layout", mainColor)

#chapter("This is a very long chapter title to test the layout", image: image("./orange2.jpg"))

== This is a very very very very very very very very very long section title to test the layout

=== This is a very very very very very very very very very long subsection title to test the layout

#part("This is a very long part title to test the layout", mainColor)

#chapter("This is a very long chapter title to test the layout", image: image("./orange2.jpg"))

== This is a very very very very very very very very very long section title to test the layout

=== This is a very very very very very very very very very long subsection title to test the layout

#part("This is a very long part title to test the layout", mainColor)

#chapter("This is a very long chapter title to test the layout", image: image("./orange2.jpg"))

== This is a very very very very very very very very very long section title to test the layout

=== This is a very very very very very very very very very long subsection title to test the layout

#part("This is a very long part title to test the layout", mainColor)

#chapter("This is a very long chapter title to test the layout", image: image("./orange2.jpg"))

#part("This is a very long part title to test the layout", mainColor)

#chapter("This is a very long chapter title to test the layout", image: image("./orange2.jpg"))

#part("This is a very long part title to test the layout", mainColor)

#chapter("This is a very long chapter title to test the layout", image: image("./orange2.jpg"))

#lorem(100)
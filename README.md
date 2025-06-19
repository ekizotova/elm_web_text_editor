# WEB text editor in _ELM_ 

## Primary goal of the application is to create simple web text editor completely in ELM

Usefull functions can be (all implemented): 
- simple text formating (bold, italic, etc.)
- layout formating (lean towards left/right/center or make header)
- add tab
- transform "-" into em-dash when needed
- download of formated text as a file 

Additional functions to think about:
- correction of spaces between words or around punctuation (something like pretty-print button)

### Main idea: to control and edit text highlighted with cursor (cursor-controlled settings) - implemented 

back-up plan: think about setting flags around the text and pretty-print at the other area 

## Project Structure

- `Main.elm` — Main Elm module handling ports, UI, and JS interop  
- `Editor.elm` — Elm module containing editor logic and state updates  
- `elm.js` — Compiled Elm JavaScript output (generated via elm make)  
- `editor.js` — JavaScript file handling editor interop  
- `index.html` — HTML file to load the Elm app and run in the browser  

---

## Prerequisites

- [Elm 0.19.1](https://guide.elm-lang.org/install/elm.html) installed  
- Optional: Node.js and npm

---

## Build Instructions

### 1. Compile Elm to JavaScript

a.
Download the project.

b.
Run this command in your project folder:

```bash
elm make Main.elm --optimize --output=elm.js

c.
Open `index.html` in your browser. 




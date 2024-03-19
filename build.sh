nim js -o:assets/main.js -d:release -f main
nim c -r --threads:on --mm:orc -f texteditor.nim
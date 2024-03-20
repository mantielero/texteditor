# nim js -o:assets/main.js main.nim
import jsffi
import quill
import std/jsconsole

let q = newQuill("#editor", "bubble", debug="info")
# q.setDebug("info")
# main()


proc onTextChangeCallback(delta, oldDelta:DeltaObj; source: cstring) =
  if source == "api":
    #callJs("console.log","An API call triggered this change.")
    echo "API"
  elif source == "user":
    #callJs("console.log","A user action triggered this change.")
    echo "USER"
    var (index,length0) = q.getSelection()
    #echo "index:",index
    #echo "length:", length
    echo "ok1"

    var line = q.getLineBlot(index)
    var offset = q.getLineOffset(index)
    #echo "- Blot name: ", $(line.blotName2)
    echo "- Line length: ", line.length()
    echo "- Line offset: ", offset
    #var line:BlotObj = q.getLine(1)[0]
    echo "ok2"
    #echoThis(line)
    #echo "Line length: ", line.length()
    #discard line.length()
    echo line.length()
    echo "end"
    #echo "ok"
    #echo "offset:", offset
    #echo line.length()
    #echo line["blotName"].to(string)
    #echo line["className"].to(string)
    #echo line.blotName
    #echo "Line content:", line.domNode.textContent
    #echo "Line length:", line.length()
    #console.log line
    #console.log line.value()
    #echo line.length() #to(int)

q.onTextChange(onTextChangeCallback)


var delta = q.deleteText(5,6)

#echo delta
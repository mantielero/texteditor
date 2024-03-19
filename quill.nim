import jsffi

when not defined(js):
  {.error: "This module only works on the JavaScript platform".}

converter toCstring*(val:string): cstring =
  val.cstring

converter toCint*(val:int): cint =
  val.cint

type
  QuillObj* = JsObject  
  DeltaObj* = JsObject
  #BlotObj* {.importc:"Blot", nodecl.} = JsObject 

  # https://github.com/quilljs/parchment
  #BlotObj* = JsObject
  BlotObj* {.importc:"Blot".} = ref object of RootObj# 
    blotName*: cstring
    # #className*: string
    length*: proc ():cint {.closure.}
    # value*: proc():JsObject {.closure.}

proc blotName(_: typedesc[BlotObj]): cstring {.importCpp: "Blot.blotName".}
#[
const options = {
  debug: 'info',
  modules: {
    toolbar: true,
  },
  placeholder: 'Compose an epic...',
  theme: 'snow'
};
]#

proc newQuillBind(id:cstring; options:JsObject = newJsObject() ): QuillObj {. importcpp: "new Quill(@)" .}

proc newQuill*(id:string; 
               options:JsObject = newJsObject() ):QuillObj =
  newQuillBind(id.cstring, options)

proc newQuill*(id:string; 
               theme:string = "snow";
               placeholder:string = "";
               debug:string = ""
               ):QuillObj =
  ## theme= snow|bubble
  var config = newJsObject()
  config["theme"] = theme.cstring
  if placeholder != "":
    config["placeholder"] = placeholder.cstring
  if debug != "":
    config["debug"] = debug

  newQuillBind(id.cstring, config)

proc setDebug(api:QuillObj; debug:cstring) {. importcpp: "#.debug(@)" .}

proc setDebug*(api:QuillObj;debug:string) =
  #'error', 'warn', 'log', or 'info'
  #if not debug in @["error", "warn", "log", "info"]:
  #  raise newException(ValueError, "not valid debug value: error, warn, log, info" )
  api.setDebug(debug.cstring)



## Events
## https://quilljs.com/docs/api#events

proc onTextChange*(api:QuillObj; 
                   f:proc(delta, oldDelta:DeltaObj; source: cstring ) 
                  ) {.importcpp:"""#.on("text-change", @)""".}


## Delta

#const Bold = Quill.import('formats/bold'); 

## Content

#https://quilljs.com/docs/api#deletetext
#deleteText(index: number, length: number, source: string = 'api'): Delta
proc deleteTextBind(api:QuillObj; index,length:cint; source:cstring): DeltaObj {.importcpp:"#.deleteText(@)".}

proc deleteText*(api:QuillObj; index,length:int; source:cstring = "api"): DeltaObj =
  api.deleteTextBind(index.cint, length.cint, source) 

proc getSelectionBind(api:QuillObj; focus:bool = false):JsObject {.importcpp:"#.getSelection(@)".}
  # getSelection(focus = false): { index: number, length: number }

proc getSelection*(api:QuillObj; focus:bool = false):tuple[index,length:int] =
  var tmp = api.getSelectionBind(focus)
  return (tmp["index"].to(int), tmp["length"].to(int))


proc getLineBind(api:QuillObj; index:cint):tuple[line:BlotObj;offset:cint] {.importcpp:"#.getLine(@)".}
# [Blot, Number]
#proc getLineBind2(api:QuillObj; index:cint):seq[JsObject] {.importcpp:"#.getLine(@)".}

proc getLine*(api:QuillObj; index:int):tuple[line:BlotObj;offset:int] =
  #var (line,offset) = api.getLineBind2(index.cint)
  var tmp = api.getLineBind(index.cint)
  echo "Line: ", tmp[0].length()
  echo "Offset: ", tmp[1]
  return tmp
  #echo repr tmp[1]
  #return #(BlotObj(tmp[0]), tmp[1].int)

#proc length*(blot:BlotObj):cint {.importcpp:"#.length()".}
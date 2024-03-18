# Linux: nim c -r --threads:on --gc:orc texteditor.nim
# Windows: nim c -r --threads:on --gc:orc --app:gui texteditor.nim
import std/[os]

import neel


#randomize()

exposeProcs:
  proc tmp() =
    discard
  # proc onTextChange(delta, oldDelta:JsObject; source: cstring) =
  #   if source == "api":
  #     callJs("console.log","An API call triggered this change.")
  #   elif source == "user":
  #     callJs("console.log","A user action triggered this change.")

      #let absPathDir = absolutePath(directory,root=getHomeDir())
      # if dirExists(absPathDir):
      #     var files: seq[string]
      #     for kind, path in absPathDir.walkDir:
      #         files.add(path)
      #     callJs("showText",sample(files))
      # else:
      #     callJs("showText", "The directory you chose does not exist.")

startApp(webDirPath= currentSourcePath.parentDir / "assets") # change path as necessary

#[
#[
quill.on('text-change', (delta, oldDelta, source) => {
  if (source == 'api') {
    console.log('An API call triggered this change.');
  } else if (source == 'user') {
    console.log('A user action triggered this change.');
  }
});
]#
]#
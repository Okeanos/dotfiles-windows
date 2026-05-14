# Miscellaneous Files

This folder contains a number of files and other folders that complement the dotfiles.

- Empty projects for some IDEs that contain e.g. settings to promote installation of some plugins.
- The icon reference file for this project used e.g. for JetBrains IDEs.

## JetBrains IDE plugins

You can use the [IDE Scripting Console](https://www.jetbrains.com/help/idea/ide-scripting-console.html)
to extract the currently installed plugins:

```kotlinscript
import com.intellij.ide.plugins.PluginManagerCore

PluginManagerCore.getPluginSet().allPlugins.map{plugin -> plugin.getPluginId()}
```

This will print an array of all ids of the installed plugins. If you want to filter the results for
example, then have a look at the [`PluginManagerCore`](https://github.com/JetBrains/intellij-community/blob/5cc01dfeac8326d77eeaf1b0bc4fc7ddf742ffa6/platform/core-impl/src/com/intellij/ide/plugins/PluginManagerCore.kt)
definition.

You can take inspiration from [this Gist](https://gist.github.com/tansautn/f492582b50cf176862635a2b05e7ebfd) as well.

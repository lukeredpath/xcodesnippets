# xcodesnippets - a utility for managing Xcode 4 snippet libraries.

Xcode 4 introduced code snippets; small, re-usable chunks of code that could be inserted using Xcode's native auto-completion system. 

The problem is, Xcode does little to nothing to help you manage these snippets. There isn't an easy way of sharing them or managing them. `xcodesnippets` aims to make snippets a little bit more manageable, and sharable through the concept of snippet bundles.

My hope is that one day that this utility becomes obsolete and Xcode itself has better support for managing snippets, including organisation into folders and native installation/activation/deactivation of snippet bundles. To that end, I have [filed a bug](http://openradar.appspot.com/radar?id=1214402) (rdar://9587558) which I encourage you to dupe if you feel this would be beneficial.

## Getting started

`xcodesnippets` is written in Ruby and distributed as a Ruby gem. Most Macs with development tools installed come with a usable version of Ruby and RubyGems although to date, this gem has only been tested against Ruby 1.9.2. If you have a problem, please [file a bug](https://github.com/lukeredpath/xcodesnippets/issues).

If you aren't familiar with RubyGems, fire up a Terminal and run the following command:

    $ sudo gem install xcodesnippets
    
If you are using a tool like [RVM](https://rvm.beginrescueend.com/), the `sudo` will probably be unnecessary.

## Migrating your existing snippets

If you already have some snippets in `~/Library/Developer/Xcode/UserData/CodeSnippets/` you will want to bring these under `xcodesnippets` control before you do anything else.

Fortunately, `xcodesnippets` will do this for you; not only that, but it will rename each snippet file to use a more meaningful title (the one you gave it within Xcode).

To migrate your exiting snippets, run:

    $ xcodesnippets migrate
    
A list of your existing snippets will be displayed and with your confirmation, they will be copied into the default `xcodesnippet` bundle, removed from the Xcode snippets directory, then re-linked back to the `xcodesnippet` versions (see "How xcodesnippets works" for more).

## Installing a code snippet

Code snippets are distributed as property list files with a `.codesnippet` extension. If you have created any custom code snippets in Xcode 4, you will find them in your home directory, under `~/Library/Developer/Xcode/UserData/CodeSnippets/`. The files are named using GUIDs. Any `codesnippet` file created from within Xcode 4, or manually if you are comfortable editing the files yourself (they are just plists) are installable using `xcodesnippets`.

To install a snippet, run the following from the terminal:

    $ xcodesnippets install [path-to-snippet-file]
    
To install a bundle, run the following:

    $ xcodesnippets install-bundle [path-to-snippet-bundle]
    
For a full list of commands and options, run `xcodesnippets --help`.
    
## How xcodesnippets works

`xcodesnippets` stores all of it's snippets inside snippet bundles. Snippet bundles are simply a directory/package with a `.snippetbundle` extension. When creating and sharing snippets, you are encouraged to give them a suitable name that indicates what the snippet does, rather than using the GUID naming scheme that Xcode uses.

`xcodesnippets` installs all of it's snippets into `~/Library/Developer/Xcode/UserData/ManagedCodeSnippets`. Standalone snippets are stored in a default snippet bundle. Snippets are then symlinked from their installed location to the Xcode code snippets directory with an appropriate GUID, ensuring that they appear in Xcode (you may need to close your current project or workspace before installed snippets appear).

## TODO

* Installing snippets and bundles directly from a URL
* Activating snippets from outside the managed directory - great for using your own snippets from their local source repos.
* Generating snippet bundles from a folder of snippets ready for distribution
* Commands for listing installed bundles and their contents
* Commands for activating and de-activating individual bundles/snippets

## License

This project is licensed under the terms of the MIT license.

Copyright (c) 2011 Luke Redpath

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


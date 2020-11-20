# Poem version 2.0

**NOTE**: I wrote Poem over 10 years ago and have not touched it since. I hope you enjoy it but it should go without saying that it's not being maintained.

Poem is designed to make using apps on your USB stick. It does this by handling file associations instead of writing to
the registry, that way you can quickly and easily open files with programs on your
flash drive.

Contents:

1. Basic
  1.1 What Poem is
  1.2 What Poem isn't
2. Registry context
3. Dropper
4. Using Poem
5. Tray
6. FAQ
7. Future Plans
8. Known Bugs
9. Changelog
10. About me!
10.1 Special thanks
11. Legal mumbo jumbo


## 1. Basic

Before you can use Poem, you need to tell it what filetypes you want associated with what programs. Run Poem without any
arguments and you'll see a blank list. Press "New" to add a new entry where you can add the filetype, the program, and
how the program takes arguments. Do this for as many filetypes as you want, then Poem is all set up!

When you close the Poem window, it will minimize to your tray. In order to completely exit Poem, right click the tray
icon and select "Exit".

### 1.1 WHAT POEM IS
 
 +Portable
 
 +Simple

### 1.2 WHAT POEM ISN't
 
 -A program launcher
 
 -Designed to be used on a stationary environment


## 2. Registry Context

One way that Poem simplifies file association is via a simple registry entry. When installed, it will add the option
"Open with Poem" when the user right clicks any file. To install it, either click the button in the Poem Editor, or
right click the tray and select "Install". The three ways to see if the registry entry is currently installed are (1)
the main window button, (2) which option is greyed out in the tray menu, and (3) holding your mouse over the tray icon.

In the context menu, the folder name that Poem is in is displayed in brackets (like "[Mozilla Firefox]"). This is there
so that if you have more than one Poem running from different places, the context keys won't be confusing.

[Many people might complain that because it purposely creates a registry key, Poem is not portable, but I beg to differ.
Others might complain that you are trading out file association registry keys for a Poem registry key, but I would argue
that Poem has only one key that is easily removed, while you must have a separate key for every filetype otherwise.
Again, the registry key is not necessary, but it makes Poem a heck of alot more useful.]


## 3.Dropper

In addition to the registry option, Poem also has a small, slimmed version of Dropper, another freeware by Qweex. It
works as a drop box that you can drop files onto which will then be passed onto Poem. It has many useful customizations
like choosing either the Poem icon or the Dropper icon, being always on top, the transparency, the background color, and
the size. Overall, it's pretty straightforward. Dropper is designed to be tiny and unobtrusive, but still allows you to
have quick access to Poem all the time.

## 4. Using Poem

After you've added any filetypes you want, you can use Poem by passing a file as an argument to Poem.exe. You can do
this by (a) dragging a file on to Poem.exe in a file manager, (b) creating a shortcut, (c) installing and using the
context option, or (d) dragging files from a file manager onto Dropper. From there, Poem will take a look at whatever
file you passed it, check what type it is, and then pass it on to whatever program you set to have that type.

[This next part might be a tad confusing to some]
There are two ways to use relative folders: relative to the drive, or relative to Poem.
    Relative to Drive means that you input the entire drive, minus the drive letter. (For example:
"E:\Portable Apps\Pidgin\Pidgin.exe" would become "Portable Apps\Pidgin\Pidgin.exe"). The drive letter will be put in
later because you might not know what the drive letter is going to be. This makes a lot of sense if you use a flash
drive since the program probably won't move, but the letter is going to change.
    Relative to Poem means that you are using Poem's location as a base for where the program is. (For example: if Poem
were in "E:\Portable Apps\FreewareWire\Poem.exe", "E:\Portable Apps\Pidgin\Pidgin.exe" would become
"..\Pidgin\Pidgin.exe") The main thing to remember is that "..\" means "up one directory" and ".\" means "this
directory".

For all paths that are relative to the drive, you can set what letter they are all on in the main window. The
default and best choice for drive letter is "Poem", which means that all of the programs are on the same drive
as Poem. The main reason for having the other letters is if one has Poem on one drive and all the programs on
another.


## 5. Tray

Poem is so simple and elegant, you can do almost everything, directly from the tray. When closing the main window, Poem
will minimize to the tray, to be out of the way but still there to help.


## 6. FAQ

Q: Why "Poem"?
A: Originally, Poem was called "PEM", which stood for "Portable Extension Manager". While the acronymn was accurate, it
   wasn't very catchy. I asked for help on my personal blog and eventually got an e-mail, and they suggested Poem. I
   loved it because it is more friendly while still remaining very close to PEM. Plus, I love poetry.

Q: I need more than one program to be associated with a type of file! Why can't Poem have more than one association?
A: Because it's not a miracle worker. Although that would be nice, that would require a new context option, new
   entries, and a ton more work. Poem is designed to be simple.

Q: [This program/filetype] doesn't work with Poem!
A: E-mail me! The address should be at the top of this Readme!
   (Seriously, that's not a BS answer...I WANT to help you!)

Q: What type of bear is best?
A: Well there are basically two schools of thought...


## 7. Future plans

-Ability to set custom Context messages?
-Add a way to delete ALL Poem contexts, in case some were left behind.
-Basically re-write Dropper to be more modular

## 8. Known bugs

-Resizing Dropper to a very large (1/2 screen size) can be jerky. So just don't do it!
-Dropper can't be transparent. IT SUCKS. I KNOW.

## 9. Changelog

- v2.0 stable
  - Renamed to Poem!
  - Completely re-written; renamed variables, cleaned up code, split source into four files: Main, GUI, Run, and Dropper
  - Added Dropper!
  - Fixed error that occurred when closing the window while maximizing and then re-opening from the tray.
  - Fixed possibly faulty Combobox in Add/Edit window
  - Removed balloon in Silent mode.
  - Other slight tweaks/fixes
  - Added traytip for uncompiled version
  - Added Statusbar in About window
  - Switched from Titan/polyethene's Anchor script to my own; Fixed it to work with Windows 7, finally!
  - Tweaked way of reading entries to make sure it only read the [key] section; fixed possible rare bug if someone entered extensions that were other entries in the INI ("drive","startInTray","width")
  - Added function to reduce memory usage
  - Added "SetWorkingDir"
  - Added "Check programs on start"
  - Added locale ability! Now I just need translators! (Uses Titan's INI Library. VERY fast.)
  - Added automatic removing of starting "." for extensions. (Why didn't I think of that sooner?!)
  - Fixed stupid small things like double clicking in the empty part of the listview edited the last selected item.
  - Added the ability to have separate instances of Poem having separate contexts (using SKAN's MD5)
  - Added icons to easily see if a program exists
  - Added ability to have paths relative to Poem
  - Fixed lack of ability to add programs with no extension
  - Switched to more reliable way of populating treeview
  - Added "Arguments"
- v0.93 beta
  - Added ability to resize window
  - Removed many "MS's" (Msgbox Syndromes)
  - Added the ability to handle multiple files
- v0.926 beta
  - Added Working Directory for programs
  - Added comments to program
- v0.925 beta
  - Added "menu" in main screen
  - Added balloon and check registry options
  - Other....stuff...
- v0.91 beta
  - Created Readme :P
  - Added About
  - Added registry context
  - Added tray options
  - Checks valid file and program
  - Minimizes to tray
  - Made icon :P
  - Sorts after new entry/edited entry
  - Added "first time" message
  - Added love balloon :P
  - Can start without INI successfully
  - Greyed out "OK" until both fields had text in Add/Edit dialog
  - Added context warning on exit
- v0.90 beta
  - Added separate drive option
  - Barely stable
  - Functions, but without context.

## 10. About me!

_Note: I wrote this back in 2010. I'm older and wiser now, but might as well leave it in._

Ello! My name is Jon Petraglia, and I'm a Computer Science student at the University of Colorado at
Denver. I've been tinkering with Autohotkey for a while now and one of the byproducts was a program called "PEM", which
eventually evolved into Poem.

I've re-written this section several times as time goes on, but here is the message I wrote in the very first Readme:
  "I came up with the idea for PEM one Sunday when I had just reformatted my EEE PC 901 the night before. I decided to
  keep the program installations to an absolute minimum, so I downloaded portable applications such as portable 7-zip,
  portable Opera, portable GIMP, etc. I was annoyed, though, that I had to manually open a file via the program,
  instead of being able to double click like when a program is installed and associated. I thought it would be very
  easy to write a middle man, something to redirect the file from the system's default program to my portable app, so
  PEM started. I wrote PEM up to 0.91 in two days, including the first version of this readme."

The reason I kept tweaking Poem is that I truly have a passion for software, especially freeware, and I hope that people
will find it useful. If you want to help me at all, the most help you can give is by helping to spread the word about
Poem and other of my softwares.
~Jon

## 10.1 Special Thanks

Special thanks to:

  - The autohotkey documentation, for making up where my understanding lacked.
  - [SciTE](http://www.scintilla.org/SciTE.html), for yet again saving me with AutoHotkey syntax, and for being portable.
  - The [GIMP](http://www.gimp.org), for being there to help me design a simple icon, and for being portable.
  - My netbook, Lewis (RIP), for handling coding at all hours of the morning.
  - Autohotkey, for being so easy, an idiot like me could do it.
  - [Titan](http://www.autohotkey.net/~Titan/), for the very very handy "Anchor" script, allowing the resizing of window (without which I could never have done.)

People who have helped find bugs:

  - Willi
  - Brother Gabriel-Marie

## 11. Legal Mumbo Jumbo

    Poem is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Poem is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with StartupSaver.  If not, see <http://www.gnu.org/licenses/>.
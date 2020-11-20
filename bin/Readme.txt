~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~PEM version 0.93~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~(C) Jon Petraglia 2010~~~~~~~~~~~~~~~~~~~
~~~~~http://sites.google.com/site/freewarewiresoftware~~~~~~
~~~~~~~~~~~~~~~~~~freewarewire@gmail.com~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PEM stands for Portable Extension Manager. It's purpose is to be able to handle file associations without writing any data to the system's registry, making it possible to defaultly open files with programs on a flash drive. 

Contents:
1. Basic
 1.1 What PEM is
 1.2 What PEM isn't
2. Registry context
3. Dropper
3. Using PEM
4. Tray
5. FAQ
6. Future Plans
7. Known Bugs
8. Changelog
9. About me!
9.1 Special thanks


1.----------Basic---------------

PEM is very simple. Run the program with no arguments to get the "PEM Editor", which edits the extension associations. The main window shows a simple table of all the file associations and their respective programs. Also shown is the drive selector and context installer/remover (both discussed below). To create a new entry, click the "New" button, enter in the data (being sure to leave out the drive letter, the colon, and the backslash). To edit an entry, double click on it in the table. To delete an entry, select it, and press the "Del" button.

When you close the PEM window, it will minimize to your tray. In order to completely exit PEM, right click the tray icon and select "Exit".

---1.1 WHAT PEM IS
 +Portable
 +Simple
---1..2 WHAT PEM ISN't
 -A program launcher
 -Designed to be used on a stationary environment


2.----------Registry Context---------------

One way that PEM simplifies file association is via a simple registry entry. When installed, it will add the option "Open with PEM" when the user right clicks any file. To install it, either click the button in the PEM Editor, or right click the tray and select "Install". The three ways to see if the registry entry is currently installed are (1) the main window button, (2) which option is greyed out in the tray menu, and (3) holding your mouse over the tray icon.

Many people might complain that because it purposely creates a registry key, PEM is not portable, but I beg to differ. Others might complain that you are trading out file association registry keys for a PEM registry key, but I would argue that PEM has only one key that is easily removed, while you must have a separate key for every filetype otherwise. Again, the registry key is not necessary, but it makes PEM a heck of alot more useful.

3.---------------Dropper---------------

In addition to the registry option, PEM also has a small, slimmed version of Dropper, another one of my freewares. It works as a Dropbox that you can drop files onto which will then be passed onto PEM. It has many useful customizations like choosing either the PEM icon or the Dropper icon, being always on top, the transparency, the background color, and the size. Overall, it's pretty straightforward. Dropper is designed to be tiny and unobtrusive, but still allows you to have quick access to PEM all the time.

4.----------Using PEM---------------
  
To really USE PEM (and not just edit the preferences), pass any file as an argument to PEM.exe. You can do this by (a) dragging a file on to PEM.exe in explorer, (b) creating a shortcut, (c) installing and using the context option, or (d) dragging files from Explorer onto Dropper. PEM basically just takes the input file, checks what type it is, looks up what program is listed for that type, then opens the file with that program. When run with an argument (input file), PEM is completely silent, and executes only for a fraction of a second.

Please note that PEM does NOT HAVE TO BE RUNNING TO LAUNCH FILES. If you want to use the registry option or create a shortcut to PEM, PEM does not need to be running in order to work. The only reason you need to keep PEM running is if you want to use Dropper or if you want to make sure to delete the registry key when you're done.

Another thing to remember is not to include the dot when entering an extension. For example, an entry for pictures would be "jpg", not ".jpg", or it will, again, not work.

Also note that when adding an entry you SHOULD NOT INCLUDE THE DRIVE LETTER, COLON, AND BACKSLASH. The reason for this is that you select what drives all the files are on via the main screen drop down list. The reason for this is simple, in that the drive letter will most likely change as you use different. This means that when inputting the location of a program, one should list the entire path, except without the drive. For example: "E:\Portable Apps\Pidgin\Pidgin.exe" would become "Portable Apps\Pidgin\Pidgin.exe". If you type in "E:\", PEM will read it as "E:\E:\Portable Apps\Pidgin\Pidgin.exe" and will not start correctly.

Furthermore, the default and best choice for drive letter is "PEM". Choosing PEM means that all of the programs are on the same drive as PEM. This means that it will autodetect what letter PEM is located on, so you don't have to even change it as you switch computers. The main reason for having the other letters is if one has PEM on one drive and all the programs on another.


5.----------Tray---------------

Because PEM is so simple, the tray takes on the role of all menus in the GUI. When closing the PEM Editor, PEM will minimize to the tray, for the main reason that the user will probably want to either edit the extension list or remove the context sometime. Again note, PEM DOES NOT HAVE TO BE RUNNING IN THE TRAY TO PROCESS FILES. The two are completely unrelated.


6.-----------FAQ-------------

Q: How do you pronounce PEM?
A: However you like. I prefer to call it "Pehm", but if you want to pronounce it "PEE EE EM", then you may.

Q: I need more than one program to be associated with a type of file! Why can't PEM have more than one association?
A: Because it's not a miracle worker. Although that would be nice, that would require a new context option, new entries, and a ton more work. PEM is designed to be simple.

Q: [This program/filetype] doesn't work with PEM!
A: E-mail me!

Q: Why does PEM look the way it does? It's stupid.
A: Now that just hurts my feelings. But seriously, PEM is supposed to be simple, short, to the point. Really, the GUI is there only because it needs to be. I squeezed as much as I thought was needed in, but beyond that, PEM is not what you'd call a "looker".

Q: What type of bear is best?
A: Well there are basically two trains of thought...


7.----------Future plans---------------

-Better icon
-Need a way to "fix" the context if it points to a different place; ie, needs to detect if the key is installed for that instance of PEM.
-Add a way to include flags/tags/what have you, like "E:\Program.exe -e %1"


8.----------Known bugs---------------

-Multiple instances can be run at the same time, meaning two PEMs can be editing the same INI, not be aware of context, etc.
-Similarly, PEM's "context is installed" may be incorrect if the entry points to a different location.
-Double clicking nothing in the listview edits the last selected entry.
-Resizing Dropper to a very large (1/2 screen size) can be jerky. So just don't do it!
-No way to do files with no extensions!


9.----------Changelog---------------
v1.0 stable
-Completely re-written; renamed variables, cleaned up code, split source into four files: Main, GUI, Run, and Dropper
-Added Dropper!
-Fixed error that occurred when closing the window while maximizing and then re-opening from the tray.
-Fixed possibly faulty Combobox in Add/Edit window
-Removed balloon in Silent mode.
-Other slight tweaks/fixes
-Added traytip for uncompiled version
-Added Statusbar in About window
-Switched from Titan/polyethene's Anchor script to my own
-Tweaked way of reading entries to make sure it only read the [key] section; fixed possible rare bug if someone entered extensions that were other entries in the INI ("drive","startInTray","width")
-Added function to reduce memory usage
-Added "SetWorkingDir"
-Added "Check programs on start"
v0.93 beta
-Added ability to resize window
-Removed many "MS's" (Msgbox Syndromes)
-Added the ability to handle multiple files
v0.926 beta
-Added Working Directory for programs
-Added comments to program
v0.925 beta
-Added "menu" in main screen
-Added balloon and check registry options
-Other....stuff...
v0.91 beta
-Created Readme :P
-Added About
-Added registry context
-Added tray options
-Checks valid file and program
-Minimizes to tray
-Made icon :P
-Sorts after new entry/edited entry
-Added "first time" message
-Added love balloon :P
-Can start without INI successfully
-Greyed out "OK" until both fields had text in Add/Edit dialog
-Added context warning on exit
v0.90 beta
-Added separate drive option
-Barely stable
-Functions, but without context.

9.----------About me!---------------

My name is Jon Petraglia. PEM is my second real program to write, the first one was called "StartupSaver". I am currently a sophmore in college taking at a community college. I've taken 2 basic programming courses, roughly know Java/Javascript, and code Autohotkey in my spare time.

I came up with the idea for PEM one Sunday when I had just reformatted my EEE PC 901 the night before. I decided to keep the program installations to an absolute minimum, so I downloaded portable applications such as portable 7-zip, portable Opera, portable GIMP, etc. I was annoyed, though, that I had to manually open a file via the program, instead of being able to double click like when a program is installed and associated. I thought it would be very easy to write a middle man, something to redirect the file from the system's default program to my portable app, so PEM started. I wrote PEM up to 0.91 in two days, including the first version of this readme.

WHAT YOU CAN DO FOR ME:
No, don't donate. Ok, but only if you really want. Ha. But seriously, there are three things that would make my day: (1) visit my freeware site, http://sites.google.com/site/freewarewiresoftware, check it out, drop a comment, and see if it's something you'd consider bookmarking, (2) e-mail me at freewarewire@gmail.com with your thanks, bugs, or suggestions, and/or (3) send me a funny picture. Just let me know you tried the program some way!

Thanks so much for trying PEM. I hope you like it, and it serves you well.
~Jon

10.1----Special Thanks----

Special thanks to:
-The autohotkey documentation, for making up where my understanding lacked.
-SciTE, for yet again saving me with AutoHotkey syntax, and for being portable.    http://www.scintilla.org/SciTE.html
-The GIMP (http://www.gimp.org), for being there to help me design a simple icon, and for being portable.
-My netbook, Lewis, for handling coding at all hours of the morning.
-Autohotkey, for being so easy, an idiot like me could do it.
-Titan, for the very very handy "Anchor" script, allowing the resizing of window (without which I could never have done.)	ttp://www.autohotkey.net/~Titan/

People who have helped find bugs:
-Willi
-Brother Gabriel-Marie
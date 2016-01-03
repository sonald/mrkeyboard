# Mr. keyboard

I, finger and my keyboard ...

**Description**:

Top hacker like live in emacs, keyboard control everything...
Unfortunately, emacs can't do everything, such as web browser, GUI multimedia application, power tool in real world.

Why not build everything with keyboard?
Like emacs style, but this time, we rebuild everything scratch from Mr. keyboard.

This is OS for top hacker, enjoy it. ;)

## Install

Install dependencies
> sudo apt-get install valac gir1.2-gee-1.0 libgee-dev libgtk-3-dev libwebkitgtk-3.0-dev libclutter-1.0-dev libclutter-gtk-1.0-dev libgtksourceview-3.0-dev libgexiv2-dev libpoppler-glib-dev libvte-2.90-dev libsqlite3-dev uuid-runtime mplayer2 -y

Build mrkeyboard main program
> make

Build mrkeyboard applications
> ./build_apps make

## Usage

Start mrkeyboard
> ./mrkeyboard.sh

Start mrkeyboard with filemanager
> ./mrkeyboard.sh filemanager /home/

Start mrkeyboard with musicplayer
> ./mrkeyboard.sh musicplayer /your_music_directory

After start mrkeyboard, you can press Win + u to start browser, Win + n to start terminal.
Other programs, such editor, imageviewer, pdfviewer, videoplayer, you can press return in filemanager, filemanager keystrokes are: j, k, f, '

After open applications, try Alt + ; and Alt + : to split window, Alt + ' and Alt + " to close window, Alt + , and Alt + . to switch tab, Alt + < and Alt + > to switch modes.

Because it's still in developing stage, start application is not so easy, I would write a launcher similar emacs-helm to use start application smartly.

## Getting involved

This project just start, any idea and suggestion are welcome.

You can contact me with lazycat.manatee@gmail.com 


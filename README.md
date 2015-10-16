# Mr. keyboard

**Description**:

Top hacker like live in emacs, keyboard control everything...
Unfortunately, emacs can't do everything, such as web browser, GUI multimedia application, power tool in real world.

Why not build everything with keyboard?
Like emacs style, but this time, we rebuild everything scratch from Mr. keyboard.

This is OS for top hacker, enjoy it. ;)

## Dependencies

vala-0.28, clutter-1.0, clutter-gtk-1.0, clutter-x11-1.0, gtk+-3.0, gdk-x11-3.0, gio-2.0, xcb

## Usage

> make && ./main

## TODO

* Fixed bug: create two terminal and create browser failed, but create one terminal and create browser is correct.
* Fixed bug: after close last tab in current window, switch mode failed, but switch mode manually is correct.
* Fixed bug: split window first, and new different mode tab to cause clone window freeze.
* Fixed bug: create different mode and then split window, switch mode to make xwindow hide other window, we need resize xwindow when switch mode.
* close_current_window/close_other_window should make origin tab to hide and not be destroyed.
* Design new protocol to make app create new tab to daemon, such as browser.
* Design search framework.
* Design application package standard.
* Design keystroke standard and build one-key system for feature. ;)
* Implement package manager and smart notify bar.
* Write terminal application with vte widget, steal ideas from https://github.com/thestinger/termite ;).
* Write browser application with webkit widget.
* Write vimium plugins for browser application.
* Write IRC application for hacking team communication.
* Write english completion plugins to make my figure faster. 
* Write movie player for life.
* Write music player for life.
* Write wifi-share for hacking at TV. ;)
* Write file-manager that powerful like dired.
* Write pdf viewer for study.
* Write image viewer to see my girl. ;)
* Write markdown editor with previewer.
* Write process manager to control process.
* Write basic editor, such as language highlight, code completion.
* Write hackable editor that powerful as emacs, then we can reach editor-strap. 
* Add welcome page.

## BUG

* Make window resize as normal, not bigger and bigger.

## Getting involved

This project just start, any idea and suggestion are welcome.

You can contact me with lazycat.manatee@gmail.com 


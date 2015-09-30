using Gtk;
using Vte;
using GLib;
using Gdk;

private static string get_shell() {
    string? shell = Vte.get_user_shell();

    if(shell == null) {
        shell = "/bin/sh";
    }

    return (!)(shell);
}

[DBus (name = "org.mrkeyboard.Daemon")]
interface Daemon : Object {
    public abstract bool create_app_window(string msg) throws IOError;
}

int main(string[] args) {
    int width = int.parse(args[1]);
    int height = int.parse(args[2]);
    
    if (GtkClutter.init(ref args) != Clutter.InitError.SUCCESS) {
        return -1;
    }
    
    var window = new Gtk.Window();
    window.set_decorated(false);
    window.set_default_size(width, height);
    window.destroy.connect(Gtk.main_quit);
    
    var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    window.add(box);
    
    var term = new Terminal();
    var arguments = new string[0];
    var shell = get_shell();
    try {
        GLib.Shell.parse_argv(shell, out arguments);
    } catch (GLib.ShellError e) {
        stdout.printf("Got error when get_shell: %s\n", e.message);
    }
    term.child_exited.connect((t) => {Gtk.main_quit();});
    try {
        term.fork_command_full(PtyFlags.DEFAULT, null, arguments, null, SpawnFlags.SEARCH_PATH, null, null);
    } catch (GLib.Error e) {
        stdout.printf("Got error when fork_command_full: %s\n", e.message);
    }
    box.pack_start(term, true, true, 0);
    
    /* Important: keep daemon variable out of try/catch scope not lose signals! */
    Daemon daemon = null;

    try {
        daemon = Bus.get_proxy_sync(BusType.SESSION, "org.mrkeyboard.Daemon",
                                                    "/org/mrkeyboard/daemon");

        window.realize.connect((w) => {
                try {
                    var xid = (ulong)((Gdk.X11.Window) window.get_window()).get_xid();
                    daemon.create_app_window(xid.to_string());
                } catch (IOError e) {
                    stderr.printf("%s\n", e.message);
                }
            });
    } catch (IOError e) {
        stderr.printf("%s\n", e.message);
    }    
    
    window.show_all();
    Gtk.main();
    
    return 0;
}
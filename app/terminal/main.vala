using Gtk;
using Vte;
using GLib;
using Gdk;
using Application;
using Gee;

[DBus (name = "org.mrkeyboard.Daemon")]
interface Daemon : Object {
    public abstract void show_app_tab(int app_win_id, string mode_name, int tab_id, string buffer_id, string window_type) throws IOError;
    public abstract void close_app_tab(string mode_name, string buffer_id) throws IOError;
    public abstract void replace_app_tab(string mode_name, int tab_id, int new_win_id) throws IOError;
    public signal void send_key_event(int window_id, uint key_val, int key_state, uint32 key_time, bool press);
    public signal void destroy_window(int window_id);
    public signal void destroy_windows(int[] window_ids);
    public signal void reparent_window(int window_id);
    public signal void resize_window(int window_id, int width, int height);
    public signal void destroy_buffer(string buffer_id);
    public signal void quit_app();
}

[DBus (name = "org.mrkeyboard.app.terminal")]
public class ClientServer : Object {
    private ArrayList<Application.Window> window_list;
    private ArrayList<Application.CloneWindow> clone_window_list;
    private HashMap<string, Application.Window> buffer_window_set;
    private HashMap<string, HashSet<Application.CloneWindow>> buffer_clone_set;
    private Daemon daemon;
    
    public int init(string[] args) {
        if (GtkClutter.init(ref args) != Clutter.InitError.SUCCESS) {
            return -1;
        }
        
        try {
            daemon = Bus.get_proxy_sync(BusType.SESSION, "org.mrkeyboard.Daemon",
                                                        "/org/mrkeyboard/daemon");
        
            daemon.send_key_event.connect((focus_window, key_val, key_state, key_time, press) => {
                    handle_send_key_event(focus_window, key_val, key_state, key_time, press);
                });
            daemon.destroy_window.connect((window_id) => {
                    handle_destroy_window(window_id);
                });
            daemon.destroy_windows.connect((window_id) => {
                    handle_destroy_windows(window_id);
                });
            daemon.reparent_window.connect((window_id) => {
                    handle_reparent(window_id);
                });
            daemon.destroy_buffer.connect((buffer_id) => {
                    handle_destroy_buffer(buffer_id) ;
                });
            daemon.resize_window.connect((window_id, width, height) => {
                    handle_resize(window_id, width, height);
                });
            daemon.quit_app.connect(() => {
                    print("Receive quit signal from daemon, quit app process...\n");
                    Gtk.main_quit();
                });
        } catch (IOError e) {
            stderr.printf("%s\n", e.message);
        }    
        
        window_list = new ArrayList<Application.Window>();
        clone_window_list = new ArrayList<Application.CloneWindow>();
        buffer_window_set = new HashMap<string, Application.Window>();
        buffer_clone_set = new HashMap<string, HashSet<Application.CloneWindow>>();
        
        create_window(args);
        
        return 0;
    }
    
    private string get_buffer_id() {
        string buffer_id;
        string[] spawn_args = {"uuidgen"};
        try {
            Process.spawn_sync(null, spawn_args, null, SpawnFlags.SEARCH_PATH, null, out buffer_id);
        } catch (SpawnError e) {
            print("Got error when spawn__line_async: %s\n", e.message);
        }
        
        return buffer_id[0:buffer_id.length - 2];  // remove \n char at end
    }
    
    public void create_window(string[] args, bool from_dbus=false) {
        if (args.length == 4) {
            var width = int.parse(args[1]);
            var height = int.parse(args[2]);
            var tab_id = int.parse(args[3]);

            var buffer_id = get_buffer_id();
            var window = new Application.Window(width, height, tab_id, buffer_id);
            
            // window.event.connect((w, e) => {
            //         print("Window %i got event %s\n", window.window_id, e.type.to_string());
            //         return false;
            //     });
            // window.delete_event.connect((w, e) => {
            //         print("got delete-event with tab_id %i window_id %i\n", tab_id, window.window_id);
            //         // Avoid unparent operation to kill window.
            //         return true;
            //     });
            // window.destroy_event.connect((w, e) => {
            //         print("got destroy-event with tab_id %i window_id %i\n", tab_id, window.window_id);
            //         // Avoid unparent operation to kill window.
            //         return true;
            //     });
            window.create_app.connect((app_win_id, mode_name, tab_id) => {
                    try {
                        daemon.show_app_tab(app_win_id, mode_name, tab_id, window.buffer_id, "origin");
                    } catch (IOError e) {
                        stderr.printf("%s\n", e.message);
                    }
                });
            window.close_app_tab.connect((mode_name, buffer_id) => {
                    try {
                        daemon.close_app_tab(mode_name, buffer_id);
                    } catch (IOError e) {
                        stderr.printf("%s\n", e.message);
                    }
                });
            window.show_all();
            
            window_list.add(window);
            buffer_window_set.set(buffer_id, window);
        } else if (args.length == 5) {
            var width = int.parse(args[1]);
            var height = int.parse(args[2]);
            var tab_id = int.parse(args[3]);
            int? parent_window_id = 0;
            
            // If four argment has '-' char, we consider it is buffer_id (uuid format).
            if ("-" in args[4]) {
                var buffer_id = args[4];
                
                var parent_window = buffer_window_set.get(buffer_id);
                parent_window_id = parent_window.window_id;
            } else {
                parent_window_id = get_parent_window_id(int.parse(args[4]));
            }
            
            if (parent_window_id != null) {
                var window = get_match_window_with_id(parent_window_id);
                if (window != null) {
                    
                    var clone_window = new Application.CloneWindow(width, height, tab_id, parent_window_id, window.buffer_id);
                    
                    // clone_window.event.connect((w, e) => {
                    //         print("Clone window %i got event %s\n", clone_window.window_id, e.type.to_string());
                    //         return false;
                    //     });
                    // clone_window.delete_event.connect((w, e) => {
                    //         print("got delete-event with tab_id %i window_id %i\n", tab_id, clone_window.window_id);                            
                    //         // Avoid unparent operation to kill window.
                    //         return true;
                    //     });
                    // clone_window.destroy_event.connect((w, e) => {
                    //         print("got destroy-event with tab_id %i window_id %i\n", tab_id, clone_window.window_id);                            
                    //         // Avoid unparent operation to kill window.
                    //         return true;
                    //     });
                    clone_window.create_app.connect((app_win_id, mode_name, tab_id) => {
                            try {
                                daemon.show_app_tab(app_win_id, mode_name, tab_id, clone_window.buffer_id, "clone");
                            } catch (IOError e) {
                                stderr.printf("%s\n", e.message);
                            }
                        });
                    clone_window.show_all();
                    clone_window_list.add(clone_window);
                
                    var clone_window_set = buffer_clone_set.get(clone_window.buffer_id);
                    if (clone_window_set == null) {
                        var clone_set = new HashSet<Application.CloneWindow>();
                        clone_set.add(clone_window);
                        buffer_clone_set.set(clone_window.buffer_id, clone_set);
                    } else {
                        clone_window_set.add(clone_window);
                    }
                }
            } else {
                print("ERROR: get_parent_window_id can't found valid window id.\n");
            }
        }
    }
    
    private int? get_parent_window_id(int window_id) {
        foreach (Application.Window window in window_list) {
            if (window.window_id == window_id) {
                return window_id;
            }
        }
        
        foreach (Application.CloneWindow clone_window in clone_window_list) {
            if (clone_window.window_id == window_id) {
                return buffer_window_set.get(clone_window.buffer_id).window_id;
            }
        }
        
        return null;
    }
    
    private void handle_send_key_event(int window_id, uint key_val, int key_state, uint32 key_time, bool press) {
        var wid = get_parent_window_id(window_id);
        if (wid != null) {
            var window = get_match_window_with_id(wid);
            if (window != null) {
                window.handle_key_event(key_val, key_state, key_time, press);
            }
        }
    }
    
    private void handle_destroy_windows(int[] window_ids) {
        foreach (int destroy_window_id in window_ids) {
            ArrayList<Application.Window> destroy_windows = new ArrayList<Application.Window>();
            foreach (Application.Window window in window_list) {
                if (window.window_id == destroy_window_id) {
                    destroy_windows.add(window);
                }
            }

            ArrayList<Application.CloneWindow> destroy_clone_windows = new ArrayList<Application.CloneWindow>();
            foreach (Application.CloneWindow clone_window in clone_window_list) {
                if (clone_window.window_id == destroy_window_id) {
                    destroy_clone_windows.add(clone_window);
                }
            }
            
            foreach (Application.Window window in destroy_windows) {
                destroy_window(window);
            }

            foreach (Application.CloneWindow clone_window in destroy_clone_windows) {
                destroy_clone_window(clone_window);
            }
        }
        
        try_quit();
    }
    
    private bool handle_destroy_window(int window_id) {
        foreach (Application.Window window in window_list) {
            if (window.window_id == window_id) {
                var clone_window_set = buffer_clone_set.get(window.buffer_id);
                if (clone_window_set == null || clone_window_set.size == 0) {
                    print("######################\n");
                    destroy_window(window);
                    
                    try_quit();
                    
                    return true;
                } else {
                    print("!!!!!!!!!!!!!!!!!!!\n");
                    foreach (CloneWindow clone_window in clone_window_set) {
                        try {
                            daemon.replace_app_tab(clone_window.mode_name, clone_window.tab_id, window.window_id);
                            print("app: replace %s %i %i\n", clone_window.mode_name, clone_window.tab_id, window.window_id);
                        } catch (IOError e) {
                            stderr.printf("Could not register service\n");
                        }
                        
                        destroy_clone_window(clone_window);
                        
                        print("app: window size %i\n", window_list.size);
                        print("app: clone window size %i\n", clone_window_list.size);
                        
                        return true;
                    }
                }                
            }
        }
        
        print("**********************\n");
        // Use temp list to remove destroy from clone_window_list to avoid error: "index < size".
        ArrayList<CloneWindow> destroy_window_list = new ArrayList<CloneWindow>();
        foreach (Application.CloneWindow clone_window in clone_window_list) {
            if (clone_window.window_id == window_id) {
                var clone_window_set = buffer_clone_set.get(clone_window.buffer_id);
                if (clone_window_set != null) {
                    clone_window_set.remove(clone_window);
                    if (clone_window_set.size == 0) {
                        buffer_clone_set.unset(clone_window.buffer_id);
                    }
                    
                }
                
                destroy_window_list.add(clone_window);
            }
        }
        
        foreach (Application.CloneWindow destroy_window in destroy_window_list) {
            clone_window_list.remove(destroy_window);
            destroy_window.destroy();
        }
        
        return false;
    }
    
    private void destroy_window(Application.Window window) {
        print("destroy_window: destroy window %i\n", window.window_id);
        buffer_window_set.unset(window.buffer_id);
        window_list.remove(window);
        window.destroy();
    }
    
    private bool destroy_clone_window(CloneWindow clone_window) {
        print("destroy_clone_window: destroy clone window %i\n", clone_window.window_id);
        clone_window_list.remove(clone_window);
        clone_window.destroy();
                
        var clone_window_set = buffer_clone_set.get(clone_window.buffer_id);
        if (clone_window_set != null) {
            clone_window_set.remove(clone_window);
            if (clone_window_set.size == 0) {
                buffer_clone_set.unset(clone_window.buffer_id);
            }
                    
            return true;
        }
        
        return true;
    }
    
    private void handle_reparent(int window_id) {
        foreach (Application.Window window in window_list) {
            if (window_id == window.window_id) {
                var clone_windows = buffer_clone_set.get(window.buffer_id);
                if (clone_windows != null) {
                    foreach (Application.CloneWindow clone_window in clone_windows) {
                        /* This is HACKING WAY!!!
                        /* TexturePixmap will freeze once parent window reparent by daemon proces.
                        /* So i use function 'replace_texture' to re-bulid new texture when parent window do x11 reparent operation.
                        /* To avoid clone texture freeze.
                        /* 
                        /* Please fix this with better way if you configure why TexturePixmap will freeze when parent window reparent.
                        */  
                        clone_window.update_texture();
                    }
                }
            }
        }
        
        foreach (Application.CloneWindow window in clone_window_list) {
            if (window_id == window.window_id) {
                window.update_texture_area();
            }
        }
    }
    
    private void handle_destroy_buffer(string buffer_id) {
        var window = buffer_window_set.get(buffer_id);
        if (window != null) {
            buffer_window_set.unset(window.buffer_id);
            window_list.remove(window);
            window.destroy();
        }
        
        var clone_windows = buffer_clone_set.get(buffer_id);
        if (clone_windows != null) {
            foreach (Application.CloneWindow clone_window in clone_windows) {
                clone_window_list.remove(clone_window);
                clone_window.destroy();
            }
            
            buffer_clone_set.unset(buffer_id);
        }

        try_quit();
    }
    
    private void try_quit() {
        if (window_list.size == 0) {
            if (clone_window_list.size != 0 || buffer_window_set.size != 0 || buffer_clone_set.size != 0) {
                print("It's something wrong with clone_window_list or buffer_window_set or buffer_clone_set.\n");
            }
            
            print("All app window destroy, exit terminal app process.\n");
            Gtk.main_quit();
        }
    }
    
    private void handle_resize(int window_id, int width, int height) {
        var window = get_match_window_with_id(window_id);
        if (window != null) {
            window.resize(width, height);
        }
    }
    
    private Application.Window? get_match_window_with_id(int window_id) {
        foreach (Application.Window window in window_list) {
            if (window_id == window.window_id) {
                return window;
            }
        }
        
        return null;
    }
}

[DBus (name = "org.mrkeyboard.app.terminal")]
interface Client : Object {
    public abstract void create_window(string[] args, bool from_dbus) throws IOError;
}

void on_bus_aquired(DBusConnection conn, ClientServer client_server) {
    try {
        conn.register_object("/org/mrkeyboard/app/terminal", client_server);
    } catch (IOError e) {
        stderr.printf("Could not register service\n");
    }
}

int main(string[] args) {
    var client_server = new ClientServer();
    
    Bus.own_name(BusType.SESSION,
                 "org.mrkeyboard.app.terminal",
                 BusNameOwnerFlags.NONE,
                 ((con) => {on_bus_aquired(con, client_server);}),
                 () => {
                     client_server.init(args);
                 },
                 () => {
                     Client client = null;
                     
                     try {
                         client = Bus.get_proxy_sync(BusType.SESSION, "org.mrkeyboard.app.terminal", "/org/mrkeyboard/app/terminal");
                         client.create_window(args, true);
                     } catch (IOError e) {
                         stderr.printf("%s\n", e.message);
                     }
                     
                     Gtk.main_quit();
                 });
    
    Gtk.main();
    
    return 0;
}

